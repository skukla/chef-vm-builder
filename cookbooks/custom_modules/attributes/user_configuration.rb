#
# Cookbook:: custom_modules
# Attribute:: user_configuration
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
custom_demo_hash = node[:custom_demo]
user_configurations = Array.new

if custom_demo_hash.has_key?(:custom_modules) && !custom_demo_hash[:custom_modules].nil?
    custom_demo_hash[:custom_modules].each do |module_key, module_value|
        converted_module_key = module_key.gsub("-", "_") if module_key.include?("-")
        next if node[:custom_modules][converted_module_key].nil? || custom_demo_hash[:custom_modules][module_key].nil?
        custom_module_config_paths = node[:custom_modules][converted_module_key][:config_paths]
        custom_module_config_paths.each do |config_path|
            custom_module_config_settings = custom_demo_hash[:custom_modules][module_key][:configuration]
            configured_setting = custom_module_config_settings.dig(*config_path.split("/"))
            configuration_setting = Hash.new
            # User-configured settings can override defaults
            if (!configured_setting.is_a? NilClass) && (!configured_setting.is_a? Chef::Node::ImmutableMash)
                configuration_setting[:path] = config_path
                configuration_setting[:value] = configured_setting
                user_configurations << configuration_setting
                next
            # User-configured settings with scope
            elsif (!configured_setting.is_a? NilClass) || (configured_setting.is_a? Chef::Node::ImmutableMash)
                ["website", "store_view"].each do |scope|
                    if configured_setting.has_key?(scope)
                        if scope == "store_view"
                            scope_value = "store"
                        else
                            scope_value = scope
                        end
                        # This should REALLY use recursion...
                        configuration_setting[:path] = config_path
                        configuration_setting[:scope] = scope_value
                        if configured_setting[scope].size > 1
                            configured_setting[scope].each do |code, value|
                                child_hash = Hash.new
                                child_hash[:path] = configuration_setting[:path]
                                child_hash[:scope] = configuration_setting[:scope]
                                child_hash[:code] = code
                                child_hash[:value] = value
                                user_configurations << child_hash
                            end
                        else
                            configured_setting[scope].each do |code, value|
                                configuration_setting[:code] = code
                                configuration_setting[:value] = value
                                user_configurations << configuration_setting
                                next
                            end
                        end
                    end
                end
            end
        end
    end
end
default[:custom_modules][:user_configuration] = user_configurations