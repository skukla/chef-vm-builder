#
# Cookbook:: magento_custom_modules
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_custom_modules][:user]
group = node[:magento_custom_modules][:user]
module_list = node[:magento_custom_modules][:module_list]

modules_array = Array.new
module_list.each do |custom_module_key, custom_module_data|
    next if custom_module_data[:settings].nil? || custom_module_data[:settings][:module_name].empty? || custom_module_data[:settings][:repository_url].empty?
    composer "Add custom repository : #{custom_module_data[:settings][:module_name]}" do
        action :add_repository
        package_name "#{custom_module_data[:settings][:module_name]}"
        repository_url "#{custom_module_data[:settings][:repository_url]}"
    end
    composer "Require custom modules" do
        action :require
        package_name "#{custom_module_data[:settings][:name]}"
        package_version "#{custom_module_data[:settings][:version] unless custom_module_data[:settings][:version].empty?}"
        options ["no-update"]
    end
end