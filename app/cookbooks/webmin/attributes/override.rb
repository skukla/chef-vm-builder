#
# Cookbook:: webmin
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:use, :port]

supported_settings.each do |setting|
    if node[:infrastructure][:webmin].is_a? Chef::Node::ImmutableMash
        next if node[:infrastructure][:webmin][setting].nil?
        override[:webmin][setting] = node[:infrastructure][:webmin][setting]
    else
        next unless (node[:infrastructure][:webmin].is_a? TrueClass) || (node[:infrastructure][:webmin].is_a? FalseClass)
        override[:webmin][:use] = node[:infrastructure][:webmin]
    end
end