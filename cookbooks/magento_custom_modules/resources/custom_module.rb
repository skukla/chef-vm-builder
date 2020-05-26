#
# Cookbook:: magento_custom_modules
# Resource:: custom_module
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :custom_module
property :name,                   String, name_property: true
property :module_name,            String
property :package_name,           String
property :package_version,        String
property :repository_url,         String
property :options,                 Array

action :download do
    composer "Add module repository : #{new_resource.module_name}" do
        action :add_repository
        package_name new_resource.module_name
        repository_url new_resource.repository_url
        not_if { new_resource.repository_url.empty? }
    end

    composer "Download module" do
        action :require
        package_name new_resource.package_name
        package_version new_resource.package_version
        options new_resource.options
    end
end
