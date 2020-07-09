#
# Cookbook:: apache
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = :http_port

if node[:infrastructure].is_a? Chef::Node::ImmutableMash
    unless node[:infrastructure][:webserver].nil?
        if node[:infrastructure][:webserver].is_a? Chef::Node::ImmutableMash
            supported_settings.each do |option|
                unless node[:infrastructure][:webserver][option].nil?
                    override[:apache][option] = node[:infrastructure][:webserver][option]
                end
            end
        end
    end
end