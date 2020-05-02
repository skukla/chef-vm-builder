#
# Cookbook:: app_configuration
# Attribute:: user_configuration
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
config_file_hash = node[:application]
user_config_settings = config_file_hash[:configuration]
default_config_settings = node[:app_configuration][:configuration]
config_paths = node[:app_configuration][:configuration_paths]

user_configurations = Array.new
config_paths.each do |config_path|
    configuration_setting = Hash.new
    # User-configured settings
    if config_file_hash.has_key?(:configuration)
        configured_setting = user_config_settings.dig(*config_path.split("/"))
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
default[:app_configuration][:user_configuration] = user_configurations