#
# Cookbook:: magento_patches
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = %i[apply repository_url repository_directory branch codebase_directory patches_file]

supported_settings.each do |setting|
  if (setting == :apply) && (node[:application][:build][:patches].is_a?(TrueClass) || node[:application][:build][:patches].is_a?(FalseClass))
    override[:magento_patches][setting] = node[:application][:build][:patches]
  elsif node[:application][:build][:patches].is_a?(Chef::Node::ImmutableMash) && node[:application][:build][:patches][setting].nil?
    override[:magento_patches][setting] = node[:application][:build][:patches][setting]
  end
end
