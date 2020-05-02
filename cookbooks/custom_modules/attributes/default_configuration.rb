#
# Cookbook:: custom_modules
# Attribute:: default_configuration
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "custom_modules::user_configuration"
custom_demo_hash = node[:custom_demo]
user_configurations = node[:custom_modules][:user_configuration]
config_paths = node[:custom_modules][:configuration_paths]
default_configurations = Array.new

if custom_demo_hash.has_key?(:custom_modules) && !custom_demo_hash[:custom_modules].nil?
    custom_demo_hash[:custom_modules].each do |module_key, module_value|
        module_key = module_key.gsub("-", "_") if module_key.include?("-")
        next unless node[:custom_modules].has_key?(module_key)
        custom_module_config_paths = node[:custom_modules][module_key][:config_paths]
        custom_module_config_paths.each do |config_path|
            configuration_setting = Hash.new
            default_config_settings = node[:custom_modules][module_key][:configuration]
            default_setting = default_config_settings.dig(*config_path.split("/"))
            if (!default_setting.is_a? NilClass) && (!default_setting.is_a? Chef::Node::ImmutableMash)
                configuration_setting[:path] = config_path
                configuration_setting[:value] = default_setting
                default_configurations << configuration_setting
            end
        end
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
default[:custom_modules][:default_configuration] = default_configurations