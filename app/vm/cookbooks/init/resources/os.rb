# Cookbook:: os
# Resource:: os
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :os
provides :os

property :name, String, name_property: true
property :user, String, default: node[:init][:os][:user]
property :group, String, default: node[:init][:os][:user]
property :timezone, String, default: node[:init][:os][:timezone]
property :install_package_list,
         Array,
         default: node[:init][:os][:install_package_list]

action :update do
	execute 'Update OS packages' do
		command "sudo apt update -y &&
        sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" &&
        sudo unattended-upgrade -d &&
        sudo apt-get autoremove -y"
	end
end

action :configure do
	execute 'Configure VM timezone' do
		command "sudo timedatectl set-timezone #{new_resource.timezone}"
	end

	group 'root' do
		members new_resource.user
		append true
		action :modify
	end
end

action :add_os_packages do
	new_resource.install_package_list.each do |package|
		apt_package package do
			action :install
		end
	end
end
