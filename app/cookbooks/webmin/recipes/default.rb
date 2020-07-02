#
# Cookbook:: webmin
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_webmin = node[:webmin][:use]
use_ssl = node[:webmin][:use_ssl]
port = node[:webmin][:port]

mailhog "Stop Mailhog" do
    action :stop
end

webmin "Uninstall Webmin" do
    action :uninstall
end

webmin "Install and configure Webmin" do
    action [:install, :configure]
    configuration({
        use_ssl: "#{use_ssl}",
        port: "#{port}"
    })
    only_if { use_webmin }
end

mailhog "Reload the mailhog daemon" do
    action :reload
    only_if { use_webmin }
end

webmin "Stop and enable Webmin" do
    action [:stop, :enable]
    only_if { use_webmin }
end