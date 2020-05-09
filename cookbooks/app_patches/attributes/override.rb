#
# Cookbook:: app_patches
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:apply, :repository_url]

if node[:application][:installation][:build][:patches].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        if node[:application][:installation][:build][:patches].has_key?(setting)
            unless node[:application][:installation][:build][:patches][setting].nil?
                override[:app_patches][setting] = node[:application][:installation][:build][:patches][setting]
            end
        end
    end
end