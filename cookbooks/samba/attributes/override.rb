#
# Cookbook:: samba
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:use, :shares]

if node[:infrastructure][:samba].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting_value|
        unless node[:infrastructure][:samba][setting_value].nil?
            override[:samba][setting_value] = node[:infrastructure][:samba][setting_value]
        end
    end
elsif node[:infrastructure].has_key?(:samba)
    unless node[:infrastructure][:samba].nil?
        override[:samba][:use] = node[:infrastructure][:samba]
    end
end