#
# Cookbook:: ssl
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:ssl_port, :ssl_locality, :ssl_region, :ssl_country]

if node[:infrastructure].is_a? Chef::Node::ImmutableMash
    unless node[:infrastructure][:webserver].nil?
        if node[:infrastructure][:webserver].is_a? Chef::Node::ImmutableMash
            supported_settings.each do |option|
                unless node[:infrastructure][:webserver][option].nil?
                    override[:ssl][option] = node[:infrastructure][:webserver][option]    
                end
            end
        end
    end
end