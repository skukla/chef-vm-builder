# Cookbook:: magento_custom_modules
# Resource:: custom_module_data
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :custom_module_data
provides :custom_module_data

property :module_list, Array
property :data_type, String

action :process do
	unless new_resource.module_list.nil?
		modules_from_github =
			new_resource.module_list.select do |md|
				md.key?('source') && md['source'].include?('github')
			end

		modules_from_github.each do |md|
			module_name = md['module_string'] if new_resource.data_type == 'data pack'
			module_name = md['name'] if new_resource.data_type == 'custom module'

			composer "Adding #{new_resource.data_type} github repository: #{module_name}" do
				action :add_repository
				module_name module_name
				repository_url md['source']
			end
		end

		modules_from_packagist =
			new_resource.module_list.select { |md| md['source'].nil? }

		require_string =
			ComposerHelper.build_require_string(
				modules_from_github.concat(modules_from_packagist),
			)

		unless require_string.empty?
			composer "Adding #{new_resource.data_type}s: #{require_string}" do
				action :require
				package_name require_string
				options ['no-update']
			end
		end
	end
end
