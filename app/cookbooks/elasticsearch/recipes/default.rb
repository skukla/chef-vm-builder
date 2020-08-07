#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_elasticsearch = node[:elasticsearch][:use]
elasticsearch_host = node[:elasticsearch][:host]
environment_file = node[:elasticsearch][:java][:environment_file]
elasticsearch_app_file = node[:elasticsearch][:app_file]

elasticsearch "Stop and uninstall Elasticsearch" do
    action [:stop, :uninstall]
end

java "Uninstall Java" do
    action :uninstall
    not_if { use_elasticsearch }
end

java "Install Java" do
    action :install
    only_if { use_elasticsearch && elasticsearch_host == "127.0.0.1" }
end

java "Set java_home in elasticsearch app file" do
    action :set_java_home
    only_if { use_elasticsearch && elasticsearch_host == "127.0.0.1" }
end

elasticsearch "Install Elasticsearch and Elasticsearch plugins and restart" do
    action [:install_app, :replace_service_file, :restart, :install_plugins, :stop]
    only_if { use_elasticsearch && elasticsearch_host == "127.0.0.1" }
end

elasticsearch "Configure Elasticsearch JVM options and Elasticsearch application" do
    action [:configure_jvm_options, :configure_app]
    only_if { use_elasticsearch && elasticsearch_host == "127.0.0.1" }
end




