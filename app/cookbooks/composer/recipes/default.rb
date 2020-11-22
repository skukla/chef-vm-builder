#
# Cookbook:: composer
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
composer 'Download and install composer application' do
  action :install_app
end

composer 'Set composer timeout' do
  action :configure_app
end

composer 'Clear composer cache' do
  action :clearcache
end
