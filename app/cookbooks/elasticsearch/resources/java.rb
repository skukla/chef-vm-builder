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
property :environment_file,         String, default: node[:elasticsearch][:java][:environment_file]

action :uninstall do
    execute "Uninstall Java" do
        command "sudo apt-get purge --auto-remove openjdk* -y"
        only_if { ::File.directory?(new_resource.java_home) }
    end
end

action :install do
    apt_package "openjdk-8-jdk" do
        action :install
        not_if { ::File.directory?(new_resource.java_home) }
    end
end

action :set_java_home do
    ruby_block "Set JAVA_HOME for environment file" do
        block do
            StringReplaceHelper.set_java_home("#{new_resource.environment_file}", "#{new_resource.java_home}")
        end
        only_if { ::File.exist?(new_resource.environment_file) }
    end
end
