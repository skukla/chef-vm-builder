#
# Cookbook:: magento_configuration
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_configuration][:web_root]
use_elasticsearch = node[:magento][:use_elasticsearch]
config_paths = node[:magento_configuration][:paths]
config_settings = node[:magento_configuration][:settings]
admin_users = node[:magento_configuration][:admin_users]
custom_modules = node[:magento_configuration][:custom_modules]
configure_base = node[:magento_configuration][:flags][:base]
configure_b2b = node[:magento_configuration][:flags][:b2b]
configure_custom_modules = node[:magento_configuration][:flags][:custom_modules]
configure_admin_users = node[:magento_configuration][:flags][:admin_users]

config_paths.each do |config_path|
    config_setting = config_settings.dig(*config_path.split("/"))
    if config_setting.is_a? Chef::Node::ImmutableMash
        ["website", "store_view"].each do |config_scope|
            # Website/Store-view-scoped settings
            if config_setting.has_key?(config_scope)
                config_setting[config_scope].each do |config_scope_code, config_value|
                    # Base Settings
                    if !config_value.nil? && !((config_value.is_a? String) && config_value.empty?) && !config_path.include?("btob") && !config_path.include?("search") && configure_base
                        magento_cli "Configuring base #{config_scope} setting for #{config_scope_code}: #{config_path}" do
                            action :config_set
                            config_path "\"#{config_path}\""
                            config_scope "\"#{config_scope}\""
                            config_scope_code "\"#{config_scope_code}\""
                            config_value "\"#{ValueHelper.process_value(config_value)}\""
                        end
                    end

                    # B2B Settings
                    if !config_value.nil? && !((config_value.is_a? String) && config_value.empty?) && config_path.include?("btob") && configure_b2b
                        magento_cli "Configuring b2b #{config_scope} setting for #{config_scope_code}: #{config_path}" do
                            action :config_set
                            config_path "\"#{config_path}\""
                            config_scope "\"#{config_scope}\""
                            config_scope_code "\"#{config_scope_code}\""
                            config_value "\"#{ValueHelper.process_value(config_value)}\""
                        end
                    end

                    # Search Settings
                    if !config_value.nil? && !((config_value.is_a? String) && config_value.empty?) && config_path.include?("search") && use_elasticsearch
                        magento_cli "Configuring search #{config_scope} setting for #{config_scope_code}: #{config_path}" do
                            action :config_set
                            config_path "\"#{config_path}\""
                            config_scope "\"#{config_scope}\""
                            config_scope_code "\"#{config_scope_code}\""
                            config_value "\"#{ValueHelper.process_value(config_value)}\""
                        end
                    end
                end
            end
        end
    # Default-scoped settings
    else
        config_value = config_setting
        # Base settings
        if !config_value.nil? && !((config_value.is_a? String) && config_value.empty?) && !config_path.include?("btob") && !config_path.include?("search") && configure_base
            magento_cli "Configuring default base setting for: #{config_path}" do
                action :config_set
                config_scope "default"
                config_path "\"#{config_path}\""
                config_value "\"#{ValueHelper.process_value(config_value)}\""
            end
        end

        # B2B settings
        if !config_value.nil? && !((config_value.is_a? String) && config_value.empty?) && config_path.include?("btob") && configure_b2b
            magento_cli "Configuring default b2b setting for: #{config_path}" do
                action :config_set
                config_scope "default"
                config_path "\"#{config_path}\""
                config_value "\"#{ValueHelper.process_value(config_value)}\""
            end
        end

        # Search settings
        if !config_value.nil? && !((config_value.is_a? String) && config_value.empty?) && config_path.include?("search") && use_elasticsearch
            magento_cli "Configuring default search setting for: #{config_path}" do
                action :config_set
                config_scope "default"
                config_path "\"#{config_path}\""
                config_value "\"#{ValueHelper.process_value(config_value)}\""
            end
        end
    end
end

if !admin_users.nil? && configure_admin_users
    admin_users.each do |field, value|
        magento_cli "Configure admin user : #{value[:first_name]} #{value[:last_name]}" do
            action :create_admin_user
            admin_username "#{value[:username]}"
            admin_password "#{value[:password]}"
            admin_email "#{value[:email]}"
            admin_firstname "#{value[:first_name]}"
            admin_lastname "#{value[:last_name]}"
        end
    end
end