#
# Cookbook:: magento
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
force_install = node[:magento][:installation][:build][:force_install]

magento_app "Uninstall Magento" do
    action :uninstall
    only_if { !Dir.empty?("#{web_root}") && force_install }
end
