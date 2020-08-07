#
# Cookbook:: php
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
webserver_type = node[:php][:init][:webserver_type]

php "Set PHP user, then install, configure, enable, and start PHP" do
    action [:set_user, :install, :configure, :enable, :restart]
end

php "Remove Apache packages" do
    action :remove_apache_packages
    only_if { webserver_type != "apache2" }
end
