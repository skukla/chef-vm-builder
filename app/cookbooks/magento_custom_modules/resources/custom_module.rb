#
# Cookbook:: magento_custom_modules
# Resource:: custom_module
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :custom_module
provides :custom_module

property :name,                   String, name_property: true
property :package_name,           String
property :module_name,            String
property :package_version,        String
property :repository_url,         String
property :options,                Array

action :download do
    composer "Add repository #{new_resource.package_name}" do
        action :add_repository
        module_name new_resource.module_name
        repository_url new_resource.repository_url
        not_if { new_resource.repository_url.empty? }
        only_if { new_resource.repository_url.include?("github.com") }
    end

    composer "Add module #{new_resource.package_name}" do
        action :require
        package_name new_resource.package_name
        package_version new_resource.package_version
        options new_resource.options
        only_if { new_resource.package_name.include?("/") }
    end
end
