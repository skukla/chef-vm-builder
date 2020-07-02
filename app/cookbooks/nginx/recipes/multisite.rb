#
# Cookbook:: nginx
# Recipe:: multisite
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
fpm_backend = node[:nginx][:fpm_backend]
fpm_port = node[:nginx][:fpm_port]
client_max_body_size = node[:nginx][:client_max_body_size]
http_port = node[:nginx][:http_port]
ssl_port = node[:nginx][:ssl_port]
cert_directory = node[:nginx][:ssl_cert_directory]
cert_file = "#{node[:fqdn]}.crt"
key_directory = node[:nginx][:ssl_key_directory]
key_file = "#{node[:fqdn]}.key"
custom_demo_structure = node[:nginx][:structure]

nginx "Clear sites-available and sites-enabled" do
    action :clear_sites
end

nginx "Configure multisite" do
    action :configure_multisite
    web_root "#{web_root}"
    custom_demo_structure custom_demo_structure
    configuration({
        http_port: http_port,
        client_max_body_size: client_max_body_size,
        fpm_backend: fpm_backend,
        fpm_port: fpm_port
    })
    ssl_configuration({
        ssl_port: ssl_port,
        key_directory: key_directory,
        key_file: key_file,
        cert_directory: cert_directory,
        cert_file: cert_file
    })
    only_if { ::File.directory?('/etc/nginx/sites-available') }
end

nginx "Enable multisite configuration" do
    action :enable_multisite
    only_if { ::File.exist?('/etc/nginx/sites-available/conf/01-multisite.conf') }
end

nginx "Restart nginx" do
    action :restart
end

php "Restart PHP" do
    action :restart
end