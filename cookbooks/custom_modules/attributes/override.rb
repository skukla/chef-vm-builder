#
# Cookbook:: custom_modules
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default_custom_modules = node[:custom_modules][:module_list]
configured_custom_modules = node[:custom_demo][:custom_modules]
user_configurations = Array.new

unless configured_custom_modules.nil?
    configured_custom_modules.each do |module_key, module_value|
        next if configured_custom_modules[module_key].nil?
        next if configured_custom_modules[module_key][:configuration].nil?
        next unless configured_custom_modules[module_key][:configuration].is_a? Chef::Node::ImmutableMash
        module_configurations = Array.new
        module_key.include?("-") ? escaped_module_key = module_key.gsub("-", "_") : escaped_module_key = module_key
        default_custom_modules[escaped_module_key][:config_paths].each do |config_path|
            configuration_setting = Hash.new
            setting_value = configured_custom_modules[module_key][:configuration].dig(*config_path.split("/"))
            unless setting_value.nil?
                configuration_setting[:path] = config_path
                configuration_setting[:value] = setting_value
                module_configurations << configuration_setting
            end
        end
        override[:custom_modules][:module_list][escaped_module_key][:settings] = module_configurations
    end
end