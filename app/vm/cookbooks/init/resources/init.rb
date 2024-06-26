# Cookbook:: init
# Resource:: init
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :init
provides :init

property :name, String, name_property: true
property :hostname, String, default: node[:hostname]
property :directory, Hash, default: node[:init][:directory]
property :functions_file, Hash, default: node[:init][:functions_file]
property :user, String, default: node[:init][:os][:user]
property :group, String, default: node[:init][:os][:user]
property :ip, String, default: node[:init][:vm][:ip]
property :vm_provider, String, default: node[:init][:vm][:provider]
property :php_version, String, default: node[:init][:php][:version]
property :search_engine_type,
         String,
         default: node[:init][:search_engine][:type]
property :search_engine_host, Hash, default: node[:init][:search_engine][:host]
property :search_engine_port, Hash, default: node[:init][:search_engine][:port]

action :install_motd do
  execute 'Make MotDs non executable' do
    command 'sudo chmod -x /etc/update-motd.d/*'
  end

  template 'Creating custom MoTD' do
    source 'custom_motd.erb'
    path '/etc/update-motd.d/01-custom'
    mode '755'
    owner 'root'
    group 'root'
    variables(
      {
        ip: new_resource.ip,
        hostname: new_resource.hostname,
        hosts: DemoStructureHelper.vm_urls,
        provider: new_resource.vm_provider,
        search_engine_type: new_resource.search_engine_type,
        search_engine_host: new_resource.search_engine_host,
        search_engine_port: new_resource.search_engine_port,
        php_version: new_resource.php_version,
        storefront_urls:
          DemoStructureHelper.vm_urls_with_protocol('storefront'),
        admin_url:
          "#{DemoStructureHelper.base_url_with_protocol('admin')}/admin",
      },
    )
  end
end

action :update_hosts do
  template 'Hosts File' do
    source 'hosts.erb'
    path '/etc/hosts'
    variables(
      { hostname: new_resource.hostname, urls: DemoStructureHelper.vm_urls },
    )
  end
end
