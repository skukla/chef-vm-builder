#
# Cookbook:: elasticsearch
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:elasticsearch][:user]
group = node[:elasticsearch][:group]
java_home = node[:elasticsearch][:java_home]
cluster_name = node[:elasticsearch][:cluster_name]
node_name = node[:elasticsearch][:node_name]
log_file_path = node[:elasticsearch][:log_file_path]
version = node[:elasticsearch][:version]
memory = node[:elasticsearch][:memory]
port = node[:elasticsearch][:port]

directory "JVM Options Custom Configuration" do
    path "/etc/elasticsearch/jvm.options.d"
    owner "#{user}"
    group "#{user}"
    mode "755"
    only_if { ::File.directory?("/etc/elasticsearch") }
end

# Configure Java Options and Elasticsearch
template "JVM Options" do
    source "jvm.options.erb"
    path "/etc/elasticsearch/jvm.options.d/jvm.options"
    user "#{user}"
    group "#{group}"
    mode '644'
    variables({ memory: "#{memory}" })
    only_if { ::File.directory?("/etc/elasticsearch/jvm.options.d") }
end

# Configure Elasticsearch
template "Elasticsearch Configuration" do
    source "elasticsearch.yml.erb"
    path "/etc/elasticsearch/elasticsearch.yml"
    user "#{user}"
    group "#{group}"
    mode "644"
    variables({ 
        cluster_name: "#{cluster_name}",
        node_name: "#{node_name}",
        log_file_path: "#{log_file_path}",
        port: "#{port}"
    })
    only_if { ::File.directory?("/etc/elasticsearch") }
end

# Set Java Home for Elasticsearch
ruby_block "Set JAVA_HOME for Elasticsearch #{version}" do
    ["/etc/environment", "/etc/default/elasticsearch"].each do |file|
        block do
            StringReplaceHelper.set_java_home("#{file}", "#{java_home}")
            only_if { ::File.exist?("#{file}") }
        end
    end
end

# Set ownership to Elasticsearch user and group
directory "/etc/elasticsearch" do
    owner "#{user}"
    group "#{group}"
    recursive true
end

service "elasticsearch" do
    action :enable
    only_if { ::File.directory?("/etc/elasticsearch") }
end
