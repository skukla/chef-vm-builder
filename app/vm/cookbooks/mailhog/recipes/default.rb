# Cookbook:: mailhog
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

go_install_path = node[:mailhog][:go_install_path]
sendmail_path = node[:mailhog][:sendmail_path]
service_file = node[:mailhog][:service_file]

golang 'Install golang' do
	action :install
	not_if { ::Dir.exist?(go_install_path) }
end

mailhog 'Stop mailhog' do
	action :stop
	only_if { ::File.exist?(service_file) }
end

mailhog 'Install, configure, enable, and reload mailhog' do
	action %i[install configure enable reload]
	not_if { ::File.exist?(service_file) }
end

include_recipe 'mailhog::configure_sendmail'
