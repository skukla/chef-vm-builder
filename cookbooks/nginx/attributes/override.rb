#
# Cookbook:: nginx
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :webserver => [
        :http_port, 
        :client_max_body_size, 
        :ssl_port, 
        :ssl_locality, 
        :ssl_region, 
        :ssl_country
    ],
    :custom_demo => :structure
}

if node[:infrastructure][:webserver].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting_key, setting_value|
        if node[:infrastructure].has_key?(setting_key) || (node[setting_key].is_a? Chef::Node::ImmutableMash)
            case setting_key
            when :webserver
                setting_value.each do |option|
                    unless (node[:infrastructure][setting_key][option].nil?) || (node[:infrastructure][setting_key][option].is_a? String) && (node[:infrastructure][setting_key][option].empty?)
                        override[:nginx][option] = node[:infrastructure][setting_key][option]
                    end
                end
            when :custom_demo
                unless node[setting_key][setting_value].nil?
                    override[:nginx][setting_value] = node[setting_key][setting_value]
                end
            end
        end
    end
end