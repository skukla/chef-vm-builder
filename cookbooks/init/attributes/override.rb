#
# Cookbook:: init
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:update, :timezone]

if node[:infrastructure][:os].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        if node[:infrastructure][:os].has_key?(setting)
            unless node[:infrastructure][:os][setting].nil?
                override[:init][setting] = node[:infrastructure][:os][setting]
            end
        end
    end
end