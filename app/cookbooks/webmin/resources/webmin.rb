#
# Cookbook:: webmin
# Resource:: webmin
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :webmin
provides :webmin

property :name,            String,            name_property: true
property :user,            String,            default: node[:webmin][:init][:user]
property :group,           String,            default: node[:webmin][:init][:user]
property :use_ssl,         [String, Integer], default: node[:webmin][:use_ssl]
property :port,            [String, Integer], default: node[:webmin][:port]

action :uninstall do
  apt_package 'webmin' do
    action %i[remove purge]
    only_if 'ls /etc/apt/sources.list.d/webmin*'
  end

  execute 'Manually remove the Webmin sources file' do
    command 'rm -rf /etc/apt/sources.list.d/webmin*'
    only_if 'ls /etc/apt/sources.list.d/webmin*'
  end
end

action :install do
  apt_repository 'webmin' do
    uri 'http://download.webmin.com/download/repository'
    distribution 'sarge'
    components ['contrib']
    key 'http://www.webmin.com/jcameron-key.asc'
    action :add
    retries 3
    ignore_failure true
    not_if { ::File.exist?('/etc/apt/sources.list.d/webmin.list') }
  end

  apt_package 'webmin' do
    action :install
  end
end

action :configure do
  template 'Webmin configuration' do
    source 'miniserv.conf.erb'
    path '/etc/webmin/miniserv.conf'
    owner new_resource.user
    group new_resource.group
    mode '644'
    variables({
                use_ssl: new_resource.use_ssl,
                port: new_resource.port
              })
  end
end

action :restart do
  service 'webmin' do
    action :start
  end
end

action :enable do
  service 'webmin' do
    action :enable
  end
end

action :stop do
  service 'webmin' do
    action :stop
  end
end
