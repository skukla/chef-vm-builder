# Cookbook:: composer
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

composer_file = node[:composer][:file]
install_dir = node[:composer][:install_dir]

composer 'Uninstall composer' do
	action :uninstall
	only_if { ::File.exist?("#{install_dir}/#{composer_file}") }
end

composer 'Download and install composer application' do
	action :install_app
end

composer 'Set composer timeout' do
	action :configure_app
end

composer 'Clear composer cache' do
	action :clear_cache
end
