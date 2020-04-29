#
# Cookbook:: custom_modules
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
custom_module_data = node[:custom_demo][:custom_modules]
composer_file = node[:custom_modules][:composer][:filename]

# Configure the repositories
modules_array = Array.new
custom_module_data.each do |custom_module_key, custom_module_value|
    if custom_module_key != "conf_options"
    execute "Add custom repositories : #{custom_module_key}" do
            command "cd #{web_root} && su #{user} -c '#{composer_file} config repositories.#{custom_module_key} git #{custom_module_value[:repository_url]}'"
        end
        # Build the require statement (Collect into an array, then join into a string)
        modules_array << "#{custom_module_value[:vendor]}/#{custom_module_key}:#{custom_module_value[:version]}"
    end
end

# Require the modules
execute "Add custom repositories" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} require --no-update #{modules_array.join(' ')}'"
end
