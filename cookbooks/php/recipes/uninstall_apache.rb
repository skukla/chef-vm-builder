#
# Cookbook:: php
# Recipe:: uninstall_apache
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
apache_packages = node[:php][:apache_packages]

# Uninstall Apache packages
apache_packages.each do |package|
    apt_package package do
        action [:remove, :purge]
        only_if "dpkg --get-selections | grep apache"
    end
end
