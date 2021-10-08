# Cookbook:: magento_custom_modules
# Resource:: custom_module_data
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :custom_module_data
provides :custom_module_data

property :module_list, Array
property :data_type, String

action :process do
	modules_from_github =
		new_resource.module_list.reject do |md|
			StringReplaceHelper.parse_source_url(md['source']).nil?
		end

	modules_from_packagist =
		new_resource.module_list.select do |md|
			StringReplaceHelper.parse_source_url(md['source']).nil? &&
				md['source'].include?('/')
		end

	modules_from_github.each do |md|
		composer "Adding #{new_resource.data_type} github repository: #{md['module_string']}" do
			action :add_repository
			module_name md['module_string']
			repository_url md['source']
		end
	end

	module_list = modules_from_github.concat(modules_from_packagist)

	unless module_list.nil? || module_list.empty?
		require_str = ComposerHelper.build_require_string(module_list)

		composer "Adding #{new_resource.data_type}s: #{require_str}" do
			action :require
			package_name require_str
			options %w[no-update]
		end
	end
end
