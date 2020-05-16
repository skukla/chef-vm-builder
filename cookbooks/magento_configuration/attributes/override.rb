#
# Cookbook:: magento_configuration
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :custom_demo => [:admin_users]
}

supported_settings.each do |top_key, top_array|
    top_array.each do |setting_value|
        next unless node[top_key][setting_value].is_a? Chef::Node::ImmutableMash
        override[:magento_configuration][setting_value] = node[top_key][setting_value]
    end
end