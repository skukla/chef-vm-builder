#
# Cookbook:: webmin
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
port = node[:infrastructure][:webmin][:port]
owner = node[:infrastructure][:webmin][:user]
group = node[:infrastructure][:webmin][:group]
use_ssl = node[:infrastructure][:webmin][:use_ssl]

# Convert use_ssl from boolean to number
use_ssl == true ? use_ssl = 1 : use_ssl = 0

# Configure webmin
template 'Webmin configuration' do
    source 'miniserv.conf.erb'
    path '/etc/webmin/miniserv.conf'
    owner "#{owner}"
    group "#{group}"
    mode "644"
    variables({
        port: "#{port}",
        use_ssl: "#{use_ssl}"
    })
end

# Reload the mailhog daemon
execute "Reload all daemons" do
    command "sudo systemctl daemon-reload"
    notifies :restart, 'service[webmin]', :immediately
end

# Define, enable, and start the webmin service
service 'webmin' do
    action [:enable, :start]
end
