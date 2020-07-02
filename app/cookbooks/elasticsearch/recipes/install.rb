#
# Cookbook:: elasticsearch
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_elasticsearch = node[:elasticsearch][:use]
java_home = node[:elasticsearch][:java][:java_home]
environment_file = node[:elasticsearch][:java][:environment_file]
version = node[:elasticsearch][:version]
plugin_list = node[:elasticsearch][:plugin_list]

java "Install Java" do
    action :install
    only_if { use_elasticsearch }
end

java "Set java_home in environment file" do
    action :set_java_home
    configuration({
        java_home: "#{java_home}",
        filename: "#{environment_file}" 
    })
    only_if { 
        use_elasticsearch &&
        ::File.exist?("#{environment_file}") 
    }
end

elasticsearch "Install Elasticsearch and Elasticsearch plugins and restart" do
    action [:install_app, :install_plugins, :restart, :stop]
    version "#{version}"
    configuration({ plugin_list: plugin_list })
    only_if { use_elasticsearch }
end