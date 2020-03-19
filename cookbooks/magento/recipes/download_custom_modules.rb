#
# Cookbook:: magento
# Recipe:: download_custom_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
web_root = node[:application][:webserver][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]
custom_module_data = node[:custom_modules]

# Configure the repositories
modules_array = Array.new
custom_module_data.each do |custom_module_key, custom_module_value|
    execute "Add custom repositories" do
        command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} config repositories.#{custom_module_key} git #{custom_module_value[:repository_url]}'"
    end
    # Build the require statement (Collect into an array, then join into a string)
    modules_array << "#{custom_module_value[:provider]}/#{custom_module_key}:#{custom_module_value[:version]}"
end

# Require the modules
execute "Add custom repositories" do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} require --no-update #{modules_array.join(' ')}'"
end
