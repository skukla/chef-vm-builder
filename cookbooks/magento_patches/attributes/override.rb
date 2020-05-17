#
# Cookbook:: magento_patches
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:apply, :repository_url, :repository_directory, :branch, :codebase_directory, :patches_file]

supported_settings.each do |setting|
    if node[:application][:installation][:build][:patches].is_a? Chef::Node::ImmutableMash
        unless node[:application][:installation][:build][:patches][setting].nil?
            override[:magento_patches][setting] = node[:application][:installation][:build][:patches][setting]
        end
    elsif (setting == :apply) && (node[:application][:installation][:build][:patches].is_a? TrueClass) || (node[:application][:installation][:build][:patches].is_a? FalseClass)
        override[:magento_patches][setting] = node[:application][:installation][:build][:patches]
    end
end