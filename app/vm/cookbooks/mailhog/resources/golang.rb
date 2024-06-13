# Cookbook:: mailhog
# Resource:: golang
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :golang
provides :golang

property :name, String, name_property: true
property :user, String, default: node[:mailhog][:init][:user]
property :tar_file, String, default: node[:mailhog][:go_file]

action :install do
  home_dir_path = ::File.join('/home', new_resource.user)
  tar_file_path = ::File.join(home_dir_path, new_resource.tar_file)

  remote_file 'Downloading go 1.21' do
    source "https://go.dev/dl/#{new_resource.tar_file}"
    path tar_file_path
    owner new_resource.user
    group new_resource.user
    mode '0755'
    action :create
  end

  archive_file 'Installing go 1.21' do
    path tar_file_path
    destination '/usr/local'
    owner 'root'
    group 'root'
    overwrite true
  end

  file 'Deleting go tar file' do
    path tar_file_path
    action :delete
    only_if { ::File.exist?(tar_file_path) }
  end
end
