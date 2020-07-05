#
# Cookbook:: elasticsearch
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_elasticsearch = node[:elasticsearch][:use]
elasticsearch_app_file = node[:elasticsearch][:app_file]

java "Set java home in elasticsearch application file" do
    action :set_java_home
    filename elasticsearch_app_file
    only_if { 
        use_elasticsearch &&
        ::File.exist?("#{elasticsearch_app_file}") 
    }
end

elasticsearch "Configure Elasticsearch JVM options and Elasticsearch application" do
    action [:configure_jvm_options, :configure_app]
    only_if { use_elasticsearch }
end