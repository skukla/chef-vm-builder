#
# Cookbook:: mailhog
# Resource:: golang
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :golang
provides :golang

property :name, String, name_property: true
property :go_install_path, String, default: node[:mailhog][:go_install_path]

action :install do
	apt_package 'golang-go' do
		action :install
	end
end
