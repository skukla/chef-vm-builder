#
# Cookbook:: magento_custom_modules
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module_list = node[:magento_custom_modules][:module_list]

module_list.each do |custom_module_key, custom_module_data|
    unless custom_module_data[:settings].nil?
        unless custom_module_data[:settings][:module_name].nil? || custom_module_data[:settings][:repository_url].nil?
            composer "Add custom repository : #{custom_module_data[:settings][:module_name]}" do
                action :add_repository
                package_name "#{custom_module_data[:settings][:module_name]}"
                repository_url "#{custom_module_data[:settings][:repository_url]}"
            end
        end

        unless custom_module_data[:settings][:name].nil?
            composer "Require custom modules" do
                action :require
                package_name "#{custom_module_data[:settings][:name]}"
                package_version "#{custom_module_data[:settings][:version] if !custom_module_data[:settings][:version].nil? && !custom_module_data[:settings][:version].empty?}"
                options ["no-update"]
            end
        end
    end
end