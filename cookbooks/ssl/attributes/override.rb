#
# Cookbook:: ssl
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:ssl_port, :ssl_locality, :ssl_region, :ssl_country]

if node[:infrastructure][:webserver].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        if node[:infrastructure][:webserver].has_key?(setting)
            override[:ssl][setting] = node[:infrastructure][:webserver][setting]
        end
    end
end