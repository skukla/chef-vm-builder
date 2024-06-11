# Cookbook:: mailhog
# Resource:: golang
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :golang
provides :golang

property :name, String, name_property: true
property :tar_file, String, default: 'go1.22.4.linux-amd64.tar.gz'

action :install do
  execute 'Downloading go 1.21' do
    command "wget -cP /home/vagrant/ https://go.dev/dl/#{new_resource.tar_file}"
  end

  execute 'Installing go 1.21' do
    command "tar -C /usr/local -xzf home/vagrant/#{new_resource.tar_file}"
  end

  execute 'Deleting go tar file' do
    command "rm -rf /home/vagrant/#{new_resource.tar_file}"
    only_if { ::File.exist?("/home/vagrant/#{new_resource.tar_file}") }
  end
end
