# Cookbook:: helpers
# Library:: app/module_shared_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

require 'json'
class ModuleSharedHelper
	def ModuleSharedHelper.define_github_url(source)
		tok = ConfigHelper.value('application/authentication/composer/github_token')
		github_raw_url = "https://#{tok}@raw.githubusercontent.com"
	end

	def ModuleSharedHelper.get_remote_package_name(source, version_str)
		github_raw_url = define_github_url(source)
		segment = StringReplaceHelper.parse_source_url(source)
		return nil if segment.nil?

		url_str =
			[
				github_raw_url,
				segment[:org],
				segment[:module],
				version_str,
				'composer.json',
			].join('/')

		JSON.parse(SystemHelper.cmd("curl -s #{url_str} | jq .name"))
	end

	def ModuleSharedHelper.set_dev_master_version(version_str)
		return 'dev-master' if version_str.nil?
		version_str
	end

	def ModuleSharedHelper.strip_version(version_str)
		slugs = %w[dev- .x-dev]
		slugs.each do |slug|
			version_str = version_str.sub(slug, '') if version_str.include?(slug)
		end
		version_str
	end

	def ModuleSharedHelper.prepare_data(hash, data_type)
		github_url = StringReplaceHelper.parse_source_url(hash['source'])

		default_vendor =
			Chef.node.default[:magento_demo_builder][:data_pack][:vendor]
		package_vendor = hash['source'].split('/')[0]

		unless github_url
			hash['vendor_string'] = default_vendor if data_type == 'dp'
			hash['vendor_string'] = package_vendor if data_type == 'cm'
			hash['package_name'] = "#{hash['vendor_string']}/#{hash['source']}"
			hash['module_string'] = hash['source']
			hash['vendor_name'] = StringReplaceHelper.to_camel(hash['vendor_string'])
			hash['module_name'] = StringReplaceHelper.to_camel(hash['module_string'])
		end

		if github_url
			hash['version'] = set_dev_master_version(hash['version'])
			stripped_version = strip_version(hash['version'])
			hash['package_name'] =
				get_remote_package_name(hash['source'], stripped_version)
			hash['vendor_string'] = hash['package_name'].split('/')[0]
			hash['vendor_name'] = hash['vendor_string']
			hash['module_string'] = hash['package_name'].split('/')[1]
			hash['module_name'] = hash['module_string']
		end
		hash
	end
end
