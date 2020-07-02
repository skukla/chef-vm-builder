#
# Cookbook:: elasticsearch
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_elasticsearch = node[:elasticsearch][:use]
java_home = node[:elasticsearch][:java][:java_home]
elasticsearch_app_file = node[:elasticsearch][:app_file]
memory = node[:elasticsearch][:memory]
port = node[:elasticsearch][:port]
cluster_name = node[:elasticsearch][:cluster_name]
node_name = node[:elasticsearch][:node_name]
log_file_path = node[:elasticsearch][:log_file_path]

java "Set java home in elasticsearch application file" do
    action :set_java_home
    configuration({
        java_home: "#{java_home}",
        filename: "#{elasticsearch_app_file}"
    })
    only_if { 
        use_elasticsearch &&
        ::File.exist?("#{elasticsearch_app_file}") 
    }
end

elasticsearch "Configure Elasticsearch JVM options and Elasticsearch application" do
    action [:configure_jvm_options, :configure_app]
    configuration({
        memory: "#{memory}",
        port: "#{port}",
        cluster_name: "#{cluster_name}",
        node_name: "#{node_name}",
        log_file_path: "#{log_file_path}"
    })
    only_if { use_elasticsearch }
end