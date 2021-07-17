#
# Cookbook:: nginx
# Resource:: nginx
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :nginx
provides :nginx

property :name,                    String,              name_property: true
property :user,                    String,              default: node[:nginx][:init][:user]
property :group,                   String,              default: node[:nginx][:init][:user]
property :package_list,            Array,               default: node[:nginx][:package_list]
property :web_root,                String,              default: node[:nginx][:web_root]
property :http_port,               [String, Integer],   default: node[:nginx][:http_port]
property :client_max_body_size,    String,              default: node[:nginx][:client_max_body_size]
property :fastcgi_buffers,         String,              default: node[:nginx][:fastcgi_buffers]
property :fastcgi_buffer_size,     String,              default: node[:nginx][:fastcgi_buffer_size]
property :fpm_backend,             String,              default: node[:nginx][:php][:fpm_backend]
property :fpm_port,                [String, Integer],   default: node[:nginx][:php][:fpm_port]
property :ssl_port,                [String, Integer],   default: node[:nginx][:ssl][:port]
property :ssl_directory,           String,              default: node[:nginx][:ssl][:directory]
property :ssl_private_key_file,    String,              default: node[:nginx][:ssl][:server_private_key_file]
property :ssl_certificate_file, String,                 default: node[:nginx][:ssl][:server_certificate_file]
property :use_secure_frontend, [String, Integer, TrueClass, FalseClass],
         default: node[:nginx][:magento][:settings][:use_secure_frontend]
property :use_secure_admin, [String, Integer, TrueClass, FalseClass],
         default: node[:nginx][:magento][:settings][:use_secure_admin]

action :uninstall do
  execute 'Remove and purge Nginx' do
    command 'apt-get --purge autoremove nginx -y'
    only_if { Dir.exist?('/etc/nginx') }
  end
end

action :install do
  new_resource.package_list.each do |package|
    apt_package package do
      action :install
    end
  end
end

action :configure_nginx do
  template 'Nginx configuration' do
    source 'nginx.conf.erb'
    path '/etc/nginx/nginx.conf'
    owner 'root'
    group 'root'
    mode '755'
    variables({
                user: new_resource.user,
                fastcgi_buffers: new_resource.fastcgi_buffers,
                fastcgi_buffer_size: new_resource.fastcgi_buffer_size
              })
  end

  link '/etc/nginx/sites-enabled/default' do
    to '/etc/nginx/sites-available/default'
    action :delete
    only_if { ::File.exist?('/etc/nginx/sites-available/default') }
  end
end

action :create_web_root do
  directory 'Web root directory' do
    path new_resource.web_root
    owner new_resource.user
    group new_resource.group
    mode '0770'
    recursive true
    not_if { ::Dir.exist?(new_resource.web_root) }
  end

  execute 'Set setgid on webroot' do
    command "chmod g+s #{new_resource.web_root}"
    only_if { ::Dir.exist?(new_resource.web_root) }
  end
end

action :clear_sites do
  Dir['/etc/nginx/sites-available/*'].each do |available_site|
    execute "Remove #{available_site}" do
      command "rm -rf #{available_site}"
    end
  end

  Dir['/etc/nginx/sites-enabled/*'].each do |enabled_site|
    execute "Remove #{enabled_site}" do
      command "rm -rf #{enabled_site}"
    end
  end
end

action :configure_multisite do
  directory 'Multisite configuration directory' do
    path '/etc/nginx/sites-available/conf'
    owner 'root'
    group 'root'
    mode '755'
    only_if { ::Dir.exist?('/etc/nginx/sites-available') }
  end

  template 'Configure Magento and Nginx' do
    source '00-nginx-magento.conf.erb'
    path '/etc/nginx/sites-available/conf/00-nginx-magento.conf'
    owner 'root'
    group 'root'
    mode '755'
    only_if { ::Dir.exist?('/etc/nginx/sites-available/conf') }
  end

  vhost_data = DemoStructureHelper.get_vhost_data

  template 'Configure multisite' do
    source '01-multisite.conf.erb'
    path '/etc/nginx/sites-available/conf/01-multisite.conf'
    owner 'root'
    group 'root'
    mode '755'
    variables({
                fpm_backend: new_resource.fpm_backend,
                fpm_port: new_resource.fpm_port,
                vhost_data: vhost_data
              })
    only_if { ::Dir.exist?('/etc/nginx/sites-available/conf') }
  end

  vhost_data.each do |vhost|
    template (vhost[:url]).to_s do
      source 'vhost.erb'
      path "/etc/nginx/sites-available/#{vhost[:url]}"
      mode '755'
      owner 'root'
      group 'root'
      variables({
                  http_port: new_resource.http_port,
                  ssl_port: new_resource.ssl_port,
                  server_name: vhost[:url],
                  client_max_body_size: new_resource.client_max_body_size,
                  web_root: new_resource.web_root,
                  use_secure_frontend: ValueHelper.process_value(new_resource.use_secure_frontend),
                  use_secure_admin: ValueHelper.process_value(new_resource.use_secure_admin),
                  ssl_directory: new_resource.ssl_directory,
                  ssl_private_key_file: new_resource.ssl_private_key_file,
                  ssl_certificate_file: new_resource.ssl_certificate_file
                })
    end

    link "/etc/nginx/sites-enabled/#{vhost[:url]}" do
      to "/etc/nginx/sites-available/#{vhost[:url]}"
      owner 'root'
      group 'root'
      only_if { ::File.exist?("/etc/nginx/sites-available/#{vhost[:url]}") }
    end
  end
end

action :enable_multisite do
  link '/etc/nginx/sites-enabled/01-multisite.conf' do
    to '/etc/nginx/sites-available/conf/01-multisite.conf'
    owner 'root'
    group 'root'
    only_if { ::File.exist?('/etc/nginx/sites-available/conf/01-multisite.conf') }
  end
end

action :set_permissions do
  ['/etc/nginx', '/var/log/nginx'].each do |directory|
    execute 'Change Nginx directory ownership' do
      command "chown -R #{new_resource.user}:#{new_resource.group} #{directory}"
    end
  end
end

action :enable do
  service 'nginx' do
    action :enable
  end
end

action :restart do
  service 'nginx' do
    action :restart
  end
end

action :stop do
  service 'nginx' do
    action :stop
  end
end
