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
        unless custom_module_data[:settings][:repository_url].nil?
            execute "Add custom repositories : #{custom_module_data[:settings][:name]}" do
                command "cd #{web_root} && su #{user} -c '#{composer_file} config repositories.#{custom_module_data[:settings][:name]} git #{custom_module_data[:settings][:repository_url]}'"
            end
        end
        # Build the require statement
        require_statement = "#{custom_module_data[:settings][:vendor]}/#{custom_module_data[:settings][:name]}"
        unless custom_module_data[:settings][:version].nil?
            require_statement = [require_statement, custom_module_data[:settings][:version]].join(":")
        end
        modules_array << require_statement
    end
    
    # Require the modules
    execute "Require custom modules" do
        command "cd #{web_root} && su #{user} -c '#{composer_file} require --no-update #{modules_array.join(" ")}'"
    end
end