#
# Cookbook:: mailhog
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_mailhog = node[:mailhog][:use]
php_version = node[:mailhog][:php][:version]
sendmail_path = node[:mailhog][:sendmail_path]
configuration = {
    port: node[:mailhog][:port],
    smtp_port: node[:mailhog][:smtp_port]
}

golang "Uninstall golang" do
    action :uninstall
    only_if { ::File.directory?("/root/go") }
end

golang "Install golang" do
    action :install
    only_if { use_mailhog }
end

mailhog "Stop and uninstall mailhog" do
    action [:stop, :uninstall]
end

mailhog "Install, configure, enable, reload, and stop  mailhog" do
    action [:install, :configure, :enable, :reload, :stop]
    configuration configuration
    only_if { use_mailhog }
end

php "Configure mailhog sendmail path and restart PHP" do
    action [:configure_sendmail, :restart]
    version "#{php_version}"
    sendmail_path "#{sendmail_path}"
end