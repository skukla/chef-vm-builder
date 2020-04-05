#
# Cookbook:: magento
# Recipe:: configure_settings
#
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]
custom_module_data = node[:custom_demo][:custom_modules]
base_configuration = node[:application][:installation][:conf_options]
custom_module_configuration = node[:custom_demo][:custom_modules][:conf_options]
admin_users = node[:custom_demo][:configuration][:admin_users]
apply_base_flag = node[:application][:installation][:options][:configuration][:base]
apply_b2b_flag = node[:application][:installation][:options][:configuration][:b2b]
apply_custom_flag = node[:application][:installation][:options][:configuration][:custom_modules]
apply_overrides_flag = node[:application][:installation][:options][:configuration][:overrides]

# Configure base application according to settings
if apply_base_flag
    base_configuration.each do |setting|
        # Build the string
        command_string = "cd #{web_root} && su #{user} -c './bin/magento config:set "
        scope_string = "--scope=#{setting[:scope]} --scope-code=#{setting[:scope_code]} " if setting.key?(:scope)
        config_string = "#{setting[:path]} \"#{setting[:value]}\"'"        
        if setting[:path].include? "elasticsearch"
            if use_elasticsearch 
                execute "Configuring base setting : #{setting[:path]}" do
                    command [command_string, scope_string, config_string].join
                end
            end
        elsif setting[:path].include? "btob"
            if apply_b2b_flag
                # TODO: Include check for b2b and get scope and code from config.json
                execute "Configuring base setting : #{setting[:path]}" do
                    command [command_string, scope_string, config_string].join
                end
            end
        else
            execute "Configuring base setting : #{setting[:path]}" do
                command [command_string, scope_string, config_string].join
            end
        end
    end
end
if apply_custom_flag
    custom_module_configuration.each do |setting|
        # Build the string
        command_string = "cd #{web_root} && su #{user} -c './bin/magento config:set "
        scope_string = "--scope=#{setting[:scope]} --scope-code=#{setting[:scope_code]} " if setting.key?(:scope)
        config_string = "#{setting[:path]} \"#{setting[:value]}\"'"
        # Configure third-party modules according to settings
        execute "Configuring custom module setting : #{setting[:path]}" do
            command [command_string, scope_string, config_string].join
        end
    end
end
if apply_overrides_flag
    # Calculate any configuration overrides
    configuraton_overrides = {
        elasticsuite: {
            path: "catalog/search/engine",
            value: "elasticsuite"
        }
    }
    overrides_array = []
    configuraton_overrides.each do |override_key, value|
        custom_module_data.keys.each do |custom_module_key|
            if override_key.to_s == custom_module_key.to_s
                overrides_array << override_key
            end
        end
    end
    # Process overrides
    overrides_array.each do |value|
        execute "Configuring overrides for  : #{configuraton_overrides[value]}" do
            command "cd #{web_root} && su #{user} -c './bin/magento config:set #{configuraton_overrides[value][:path]} \"#{configuraton_overrides[value][:value]}\"'"
        end
    end
end
