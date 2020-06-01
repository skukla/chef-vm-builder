#
# Cookbook:: webmin
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
service 'webmin' do
    action :stop
end

# Uninstall webmin
apt_package "webmin" do
    action [:remove, :purge]
end

# Manually remove the sources list file
execute "Manually remove the Webmin sources file" do
    command "sudo rm -rf /etc/apt/sources.list.d/webmin*"
    only_if { ::File.exist?('/etc/apt/sources.list.d/webmin.list') }
end
