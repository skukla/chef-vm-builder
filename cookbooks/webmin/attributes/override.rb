#
# Cookbook:: webmin
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:use, :port]

if node[:infrastructure][:webmin].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting_value|
        unless node[:infrastructure][:webmin][setting_value].nil?
            override[:webmin][setting_value] = node[:infrastructure][:webmin][setting_value]
        end
    end
elsif node[:infrastructure].has_key?(:webmin)
    unless node[:infrastructure][:webmin].nil?
        override[:webmin][:use] = node[:infrastructure][:webmin]
    end
end