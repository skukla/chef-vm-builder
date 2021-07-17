# Cookbook:: magento_custom_modules
# Resource:: custom_module_data
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :custom_module_data
provides :custom_module_data

property :module_list, Array
property :data_type, String

action :process do
  unless new_resource.module_list.empty?

    modules_from_github = new_resource.module_list.select do |module_data|
      module_data.key?(:repository_url) && module_data[:repository_url].include?('github')
    end

    modules_from_github.each do |module_data|
      next if module_data.nil? || (module_data.is_a?(String) && module_data.empty?)

      composer "Adding #{new_resource.data_type} github repository: #{module_data[:name]}" do
        action :add_repository
        module_name module_data[:name]
        repository_url module_data[:repository_url]
      end
    end

    modules_from_packagist = new_resource.module_list.select do |module_data|
      module_data[:repository_url].nil?
    end

    require_string = ModuleListHelper.build_require_string(modules_from_github.concat(modules_from_packagist))

    unless require_string.empty?
      composer "Adding #{new_resource.data_type}s: #{require_string}" do
        action :require
        package_name require_string
        options ['no-update']
      end
    end
  end
end
