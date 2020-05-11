#
# Cookbook:: custom_modules
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:custom_modules][:user]
group = node[:custom_modules][:user]
web_root = node[:custom_modules][:web_root]
composer_file = node[:custom_modules][:composer_file]
custom_module_data = node[:custom_modules][:module_list]

# Configure the repositories
unless custom_module_data.nil?
    modules_array = Array.new
    custom_module_data.each do |custom_module_key, custom_module_value|
        execute "Add custom repositories : #{custom_module_key}" do
            command "cd #{web_root} && su #{user} -c '#{composer_file} config repositories.#{custom_module_key} git #{custom_module_value[:repository_url]}'"
        end
        # Build the require statement
        modules_array << "#{custom_module_value[:vendor]}/#{custom_module_key}:#{custom_module_value[:version]}"
    end

    # Require the modules
    execute "Add custom repositories" do
        command "cd #{web_root} && su #{user} -c '#{composer_file} require --no-update #{modules_array.join(' ')}'"
    end
end
