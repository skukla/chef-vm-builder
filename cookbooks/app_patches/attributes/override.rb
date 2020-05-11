#
# Cookbook:: app_patches
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :patches => [:apply, :repository_url]
}

supported_settings.each do |setting_key, setting_value|
    next unless node[:application][:installation][:build][setting_key].is_a? Chef::Node::ImmutableMash
    unless node[:application][:installation][:build][setting_key].nil?
        override[:app_patches][setting_key] = node[:application][:installation][:build][setting_key][setting_value]
    end
end