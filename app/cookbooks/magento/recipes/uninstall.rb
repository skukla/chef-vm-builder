#
# Cookbook:: magento
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]

magento_app "Uninstall Magento" do
    action :uninstall
    not_if { ::Dir.empty?(web_root) }
    only_if { build_action == "force_install" }
end
