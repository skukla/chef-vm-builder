#
# Cookbook:: magento_configuration
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :custom_demo => [:admin_users],
    :configuration_settings => [:configuration],
    :configuration_flags => [:base, :b2b, :custom_modules, :admin_users]
}
supported_settings.each do |top_key, top_array|
    case top_key
    when :custom_demo
        top_array.each do |setting|
            if node[top_key][setting].is_a? Chef::Node::ImmutableMash
                unless node[top_key][setting].nil?
                    override[:magento_configuration][:admin_users] = node[top_key][setting]
                end
            end
        end
    when :configuration_flags
        top_array.each do |setting|
            if node[:application][:installation][:build][:configuration].is_a? Chef::Node::ImmutableMash
                unless node[:application][:installation][:build][:configuration][setting].nil?
                    override[:magento_configuration][:flags][setting] = node[:application][:installation][:build][:configuration][setting]
                end
            end
        end
    when :configuration_settings
        top_array.each do |setting|
            if node[:application][:configuration].is_a? Chef::Node::ImmutableMash
                override[:magento_configuration][:settings] = node[:application][setting]
            end
        end
    end
end