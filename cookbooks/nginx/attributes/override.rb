#
# Cookbook:: nginx
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :webserver => [:http_port, :client_max_body_size, :ssl_port, :ssl_locality, :ssl_region, :ssl_country],
    :magento_build => :web_root,
    :custom_demo => :structure
}

supported_settings.each do |setting_key, setting_value|
    case setting_key
    when :webserver
        next unless node[:infrastructure][setting_key].is_a? Chef::Node::ImmutableMash
        setting_value.each do |option|
            next unless (node[:infrastructure][setting_key][option].nil?) || (node[:infrastructure][setting_key][option].is_a? String) && (node[:infrastructure][setting_key][option].empty?)
            override[:nginx][option] = node[:infrastructure][setting_key][option]
        end
    when :magento_build
        unless node[:application][:installation][:options][:directory].nil?
            override[:nginx][setting_value] = node[:application][:installation][:options][:directory]
        end
    when :custom_demo
        unless node[setting_key][setting_value].nil?
            override[:nginx][setting_value] = node[setting_key][setting_value]
        end
    end
end