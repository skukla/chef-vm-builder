# Cookbook:: mailhog
# Resource:: mailhog
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :mailhog
provides :mailhog

property :name, String, name_property: true
property :repository_list, Array, default: node[:mailhog][:repositories]
property :go_path, String, default: node[:mailhog][:go_path]
property :go_env_path, String, default: node[:mailhog][:go_env_path]
property :install_path, String, default: node[:mailhog][:install_path]
property :service_file, String, default: node[:mailhog][:service_file]
property :mh_port, String, default: node[:mailhog][:mh_port]
property :smtp_port, String, default: node[:mailhog][:smtp_port]

action :install do
  ruby_block 'Adding go to PATH' do
    block { ENV['PATH'] = "#{ENV['PATH']}:#{new_resource.go_env_path}" }
  end

  new_resource.repository_list.each do |repository|
    execute "Use go to clone #{repository[:name]}" do
      command MailhogHelper.install_cmd(repository[:url])
    end

    execute "Copy #{repository[:name]} into #{new_resource.install_path}" do
      command "cp #{new_resource.go_path}/bin/#{repository[:name]} #{new_resource.install_path}/#{repository[:name].downcase}"
    end
  end
end

action :configure do
  template 'Mailhog service' do
    source 'mailhog.service.erb'
    path new_resource.service_file
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      { mh_port: new_resource.mh_port, smtp_port: new_resource.smtp_port },
    )
  end
end

action :restart do
  service 'mailhog' do
    action :restart
  end
end

action :enable do
  service 'mailhog' do
    action :enable
  end
end

action :reload do
  execute 'Reload all daemons' do
    command 'systemctl daemon-reload'
  end
end

action :stop do
  service 'mailhog' do
    action :stop
  end
end
