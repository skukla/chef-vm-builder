#
# Cookbook:: app_configuration
# Attribute:: default_configuration
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "app_configuration::user_configuration"
config_file_hash = node[:application]
default_config_settings = node[:app_configuration][:configuration]
config_paths = node[:app_configuration][:configuration_paths]
user_configurations = node[:app_configuration][:user_configuration]
default_configurations = Array.new

config_paths.each do |config_path|
    configuration_setting = Hash.new
    default_setting = default_config_settings.dig(*config_path.split("/"))
    if (!default_setting.is_a? NilClass) && (!default_setting.is_a? Chef::Node::ImmutableMash)
        configuration_setting[:path] = config_path
        configuration_setting[:value] = default_setting
        default_configurations << configuration_setting
    end
end
result = Array.new
# Remove duplicates from the default configurations
default_configurations.each do |default_setting|
    if !user_configurations.select{ |user_setting| user_setting[:path] == default_setting[:path] }.empty?
        result << user_configurations.select{ |user_setting| user_setting[:path] == default_setting[:path] }
    end
end
result.flatten.each do |duplicate|
    default_configurations.delete_if{ |default_setting| default_setting[:path] == duplicate[:path] }
end
default[:app_configuration][:default_configuration] = default_configurations