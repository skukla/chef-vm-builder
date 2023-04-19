# Cookbook:: mailhog
# Recipe:: mailhog
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

provider = node[:mailhog][:vm][:provider]
template_path = node[:mailhog][:systemd_template_path]
service_file = node[:mailhog][:systemd_service_file]
init_d_template_path = node[:mailhog][:init_d_template_path]
init_d_service_file = node[:mailhog][:init_d_service_file]

if provider == 'docker'
  template_path = init_d_template_path
  service_file = init_d_service_file
end

mailhog 'Stop mailhog' do
  action :stop
  only_if { ::File.exist?(service_file) }
end

mailhog 'Install mailhog' do
  action :install
  not_if { ::File.exist?(service_file) }
end

mailhog "Configure mailhog service: #{service_file}" do
  action :configure
  template_path template_path
  service_file service_file
end

unless provider == 'docker'
  mailhog 'Enable mailhog' do
    action :enable
    only_if { ::File.exist?(service_file) }
  end

  mailhog 'Reload service' do
    action :reload
    only_if { ::File.exist?(service_file) }
  end
end
