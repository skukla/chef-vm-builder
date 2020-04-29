#
# Cookbook:: php
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:version, :port, :memory_limit, :upload_max_filesize]

if node[:infrastructure][:php].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        if node[:infrastructure][:php].has_key?(setting)
            unless node[:infrastructure][:php][setting].nil?
                override[:php][setting] = node[:infrastructure][:php][setting]
            end
        end
    end
elsif node[:infrastructure].has_key?(:php)
    unless node[:infrastructure][:php].nil?
        override[:php][:version] = node[:infrastructure][:php]
    end
end