#
# Cookbook:: mailhog
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:use, :port, :smtp_port]

if node[:infrastructure][:mailhog].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting_value|
        unless node[:infrastructure][:mailhog][setting_value].nil?
            override[:mailhog][setting_value] = node[:infrastructure][:mailhog][setting_value]
        end
    end
elsif node[:infrastructure].has_key?(:mailhog)
    unless node[:infrastructure][:mailhog].nil?
        override[:mailhog][:use] = node[:infrastructure][:mailhog]
    end
end
