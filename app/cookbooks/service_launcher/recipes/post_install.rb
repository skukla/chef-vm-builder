#
# Cookbook:: service_launcher
# Recipe:: post_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_mailhog = node[:service_launcher][:mailhog][:use]
use_samba = node[:service_launcher][:samba][:use]
use_webmin = node[:service_launcher][:webmin][:use]

mailhog "Restart Mailhog" do
    action :restart
    only_if { use_mailhog }
end

samba "Restart Samba" do
    action :restart
    only_if { use_samba }
end

webmin "Restart Webmin" do
    action :restart
    only_if { use_webmin }
end