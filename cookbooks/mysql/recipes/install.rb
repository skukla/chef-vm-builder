#
# Cookbook:: mysql
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Add MariaDB repository
apt_repository 'MariaDB' do
    uri 'http://mirror.zol.co.zw/mariadb/repo/10.3/ubuntu'
    arch 'amd64'
    components ['main']
    distribution 'bionic'
    keyserver 'keyserver.ubuntu.com'
    key 'F1656F24C74CD1D8'
    deb_src true
    trusted true
    not_if { ::File.directory?('/etc/mysql') }
end

['mariadb-server', 'mariadb-client'].each do |package|
    apt_package package do
        action :install
        not_if { ::File.directory?('/etc/mysql') }
    end
end

service 'mysql' do
    action [:enable]
end
