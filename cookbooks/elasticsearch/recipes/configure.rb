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
plugins = node[:elasticsearch][:plugins]

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
ruby_block "Set JAVA_HOME in /etc/environment" do
    block do
        file = Chef::Util::FileEdit.new("/etc/environment")
        file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.write_file
    end
    only_if { ::File.exists?('/etc/environment') }
end

ruby_block "Set JAVA_HOME for Elasticsearch #{version}" do
    block do
        file = Chef::Util::FileEdit.new("/etc/default/elasticsearch")
        file.insert_line_if_no_match(/^#JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.search_file_replace_line(/^#JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.write_file
    end
    only_if { ::File.exists?("/etc/default/elasticsearch") }
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
