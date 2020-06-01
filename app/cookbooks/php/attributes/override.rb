#
# Cookbook:: php
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:version, :port, :memory_limit, :upload_max_filesize]

supported_settings.each do |setting|
    if node[:infrastructure][:php].is_a? Chef::Node::ImmutableMash
        next if node[:infrastructure][:php][setting].nil?
        override[:php][setting] = node[:infrastructure][:php][setting]
    else
        next unless (node[:infrastructure][:php].is_a? String)
        override[:php][:version] = node[:infrastructure][:php]
    end
end