# Cookbook:: mailhog
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

sendmail_path = node[:mailhog][:sendmail_path]
service_file = node[:mailhog][:service_file]

golang 'Install golang' do
	action :install
end

mailhog 'Stop mailhog' do
	action :stop
	only_if { ::File.exist?(service_file) }
end

mailhog 'Install, configure, enable, and reload mailhog' do
	action %i[install configure enable reload]
end

php 'Configure mailhog sendmail path and restart PHP' do
	action %i[configure_sendmail restart]
	sendmail_path sendmail_path
end
