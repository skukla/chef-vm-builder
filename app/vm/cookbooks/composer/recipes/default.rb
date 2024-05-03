# Cookbook:: composer
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

user = node[:composer][:init][:user]
web_root = node[:composer][:nginx][:web_root]
version = node[:composer][:version]
clear_cache = node[:composer][:clear_cache]

composer 'Uninstall composer' do
  action :uninstall
  not_if do
    ::File.exist?("/home/#{user}/.composer-version") &&
      StringReplaceHelper.find_in_file(
        "/home/#{user}/.composer-version",
        version,
      )
  end
end

composer 'Download and install composer application' do
  action :install_app
end

composer 'Set composer timeout' do
  action :config
  setting 'process-timeout'
  value 2000
  options %w[global]
end

composer 'Clear composer cache' do
  action :clear_cache
  only_if { ::Dir.exist?(web_root) && clear_cache }
end
