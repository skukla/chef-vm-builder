#
# Cookbook:: composer
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:clear_composer_cache]

if node[:application][:installation][:build].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        if node[:application][:installation][:build].has_key?(setting)
            unless node[:application][:installation][:build][setting].nil?
                override[:composer][setting] = node[:application][:installation][:build][setting]
            end
        end
    end
end