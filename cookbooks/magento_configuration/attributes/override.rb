#
# Cookbook:: magento_configuration
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :custom_demo => [:admin_users],
    :configuration => [:base, :b2b, :custom_modules, :admin_users]
}

supported_settings.each do |top_key, top_array|
    case top_key
    when :custom_demo
        top_array.each do |setting|
            if node[top_key][setting].is_a? Chef::Node::ImmutableMash
                override[:magento_configuration][setting] = node[top_key][setting]
            end
        end
    when :configuration
        if node[:application][:installation][:build][top_key].is_a? Chef::Node::ImmutableMash
            top_array.each do |setting|
                override[:magento_configuration][:flags][setting] = node[:application][:installation][:build][top_key][setting]
            end
        end
    end
end