#
# Cookbook:: mailhog
# Resource:: golang 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :golang
provides :golang

property :name,                     String, name_property: true

action :uninstall do
    execute "Uninstall Golang" do
        command "sudo apt-get remove golang-go -y && sudo apt-get purge --auto-remove golang-go* -y && rm -rf /usr/local/go/ && rm -rf /root/go"
    end
end

action :install do
    apt_package 'golang-go' do
        action :install
    end
end
