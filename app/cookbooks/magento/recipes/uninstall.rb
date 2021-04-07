#
# Cookbook:: magento
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]

if ::Dir.exist?(web_root) && !::Dir.empty?(web_root) && %w[force_install restore].include?(build_action)
  magento_app 'Uninstall Magento' do
    action :uninstall
  end
end
