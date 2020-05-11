#
# Cookbook:: custom_modules
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:custom_modules][:user]
group = node[:custom_modules][:user]
web_root = node[:custom_modules][:web_root]
composer_file = node[:custom_modules][:composer_file]
module_list = node[:custom_modules][:module_list]

# Configure the repositories
unless module_list.nil?
    modules_array = Array.new
    module_list.each do |custom_module_key, custom_module_data|
        next if custom_module_data[:settings].nil?
        custom_module_key.include?("_") ? escaped_module_key = custom_module_key.gsub("_", "-") : escaped_module_key = custom_module_key
        execute "Add custom repositories : #{escaped_module_key}" do
            command "cd #{web_root} && su #{user} -c '#{composer_file} config repositories.#{escaped_module_key} git #{custom_module_data[:settings][:repository_url]}'"
        end
        # Build the require statement
        modules_array << "#{custom_module_data[:settings][:vendor]}/#{escaped_module_key}:#{custom_module_data[:settings][:version]}"
    end

    # Require the modules
    execute "Add custom repositories" do
        command "cd #{web_root} && su #{user} -c '#{composer_file} require --no-update #{modules_array.join(' ')}'"
    end
end
