#
# Cookbook:: nginx
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:http_port]

if node[:infrastructure][:webserver].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        if node[:infrastructure][:webserver].has_key?(setting)
            unless node[:infrastructure][:webserver][setting].nil?
                override[:nginx][setting] = node[:infrastructure][:webserver][setting]
            end
        end
    end
end