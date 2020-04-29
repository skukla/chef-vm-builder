#
# Cookbook:: webmin
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
use_ssl = node[:webmin][:use_ssl]
port = node[:webmin][:port]

# Configure webmin
template 'Webmin configuration' do
    source 'miniserv.conf.erb'
    path '/etc/webmin/miniserv.conf'
    owner "#{user}"
    group "#{group}"
    mode "644"
    variables({
        use_ssl: "#{use_ssl}",
        port: "#{port}"
    })
end

# Reload the mailhog daemon
execute "Reload all daemons" do
    command "sudo systemctl daemon-reload"
    notifies :restart, 'service[webmin]', :immediately
end

# Define, enable, and start the webmin service
service 'webmin' do
    action :enable
end
