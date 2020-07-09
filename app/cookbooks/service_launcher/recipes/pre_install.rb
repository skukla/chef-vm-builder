#
# Cookbook:: service_launcher
# Recipe:: pre_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
webserver_type = node[:service_launcher][:init][:webserver_type]
use_elasticsearch = node[:service_launcher][:elasticsearch][:use]

mysql "Restart Mysql" do
    action :restart
end

nginx "Restart Nginx" do
    action :restart
    only_if { webserver_type == "nginx" }
end

apache "Restart Apache" do
    action :restart
    only_if { webserver_type == "apache2" }
end

elasticsearch "Restart Elasticsearch" do
    action :restart
    only_if { use_elasticsearch }
end