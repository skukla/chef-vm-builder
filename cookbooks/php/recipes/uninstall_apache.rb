#
# Cookbook:: php
# Recipe:: uninstall_apache
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
supported_versions = node[:infrastructure][:php][:supported_versions]

# Build Apache package list
apache_packages = ['apache2', 'apache2-bin', 'apache2-data', 'apache2-utils']
apache_modules = Array.new
apache_packages.concat(apache_modules)

# Uninstall Apache packages
apache_packages.each do |package|
    apt_package package do
        action [:remove, :purge]
        only_if "dpkg --get-selections | grep apache"
    end
end
