#
# Cookbook:: mailhog
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:use, :port, :smtp_port]

supported_settings.each do |setting|
    if node[:infrastructure][:mailhog].is_a? Chef::Node::ImmutableMash
        next if node[:infrastructure][:mailhog][setting].nil?
        override[:mailhog][setting] = node[:infrastructure][:mailhog][setting]
    else
        next unless (node[:infrastructure][:mailhog].is_a? TrueClass) || (node[:infrastructure][:mailhog].is_a? FalseClass)
        override[:mailhog][:use] = node[:infrastructure][:mailhog]
    end
end
