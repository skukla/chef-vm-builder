#
# Cookbook:: init
# Recipe:: manage_packages
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
packages_to_install = node[:init][:os][:install_package_list]
apache_packages = node[:init][:os][:apache_package_list]
webserver_type = node[:init][:webserver][:type]

# Install some useful OS packages
packages_to_install.each do |package|
    apt_package package do
        action :install
    end
end

# Uninstall apache packages
if webserver_type == "nginx"
    apache_packages.each do |package|
        apt_package package do
            action [:remove, :purge]
            only_if "dpkg --get-selections | grep apache"
        end
    end
end
