#
# Cookbook:: elasticsearch
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_elasticsearch = node[:elasticsearch][:use]
environment_file = node[:elasticsearch][:java][:environment_file]

java "Install Java" do
    action :install
    only_if { use_elasticsearch }
end

java "Set java_home in environment file" do
    action :set_java_home
    filename environment_file
    only_if { 
        use_elasticsearch &&
        ::File.exist?("#{environment_file}") 
    }
end

elasticsearch "Install Elasticsearch and Elasticsearch plugins and restart" do
    action [:install_app, :install_plugins, :restart, :stop]
    only_if { use_elasticsearch }
end