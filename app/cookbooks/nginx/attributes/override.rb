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

if node[:infrastructure].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting_key, setting_value|
        case setting_key
        when :webserver
            next if node[:infrastructure][setting_key].nil?
            if setting_value.is_a? Chef::Node::ImmutableMash
                setting_value.each do |option|
                    next if node[:infrastructure][setting_key][option].nil?
                    override[:nginx][option] = node[:infrastructure][setting_key][option]    
                end
            end
        when :magento_build
            next if node[:application][:installation][:options][:directory].nil?
            override[:nginx][setting_value] = node[:application][:installation][:options][:directory]
        when :custom_demo
            next if node[setting_key][setting_value].nil?
            override[:nginx][setting_value] = node[setting_key][setting_value]
        end
    end
end