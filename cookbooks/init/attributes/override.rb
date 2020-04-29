#
# Cookbook:: init
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:timezone]

if node[:infrastructure][:os].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        override[:init][setting] = node[:infrastructure][:os][setting]
    end
end