# Cookbook:: mailhog
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

go_env_path = node[:mailhog][:go_env_path]
service_file = node[:mailhog][:service_file]

golang 'Install golang' do
  action :install
  not_if { ::Dir.exist?(go_env_path) }
end

mailhog 'Stop mailhog' do
  action :stop
  only_if { ::File.exist?(service_file) }
end

mailhog 'Install and configure mailhog' do
  action %i[install configure]
  not_if { ::File.exist?(service_file) }
end

include_recipe 'mailhog::enable'

mailhog 'Reload mailhog' do
  action :reload
end

include_recipe 'mailhog::configure_sendmail'
