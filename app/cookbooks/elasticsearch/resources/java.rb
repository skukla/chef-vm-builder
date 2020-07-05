#
# Cookbook:: elasticsearch
# Resource:: java 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :java
provides :java

property :name,                     String, name_property: true
property :elasticsearch_version,    String, default: node[:elasticsearch][:version]
property :java_home,                String, default: node[:elasticsearch][:java][:java_home]
property :filename,                 String

action :uninstall do
    execute "Uninstall Java" do
        command "sudo apt-get purge --auto-remove openjdk* -y"
        only_if "which java"
    end
end

action :install do
    apt_package 'default-jdk' do
        action :install
        not_if "which java"
    end
end

action :set_java_home do
    ruby_block "Set JAVA_HOME for Elasticsearch #{new_resource.elasticsearch_version}" do
        block do
            StringReplaceHelper.set_java_home("#{new_resource.filename}", "#{new_resource.java_home}")
        end
    end
end
