#
# Cookbook:: elasticsearch
# Resource:: java
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :java
provides :java

property :name,                     String, name_property: true
property :package_name,             String, default: node[:elasticsearch][:java][:package]
property :java_home,                String, default: node[:elasticsearch][:java][:home]
property :environment_file,         String, default: node[:elasticsearch][:java][:environment_file]

action :uninstall do
  execute 'Uninstall Java' do
    command "apt-get purge --auto-remove #{new_resource.package_name} -y"
    only_if { ::Dir.exist?(new_resource.java_home) }
  end
end

action :install do
  apt_package new_resource.package_name do
    action :install
    not_if { ::Dir.exist?(new_resource.java_home) }
  end
end

action :set_java_home do
  ruby_block 'Set JAVA_HOME for environment file' do
    block do
      StringReplaceHelper.set_java_home(new_resource.environment_file.to_s, new_resource.java_home.to_s)
    end
    only_if { ::File.exist?(new_resource.environment_file) }
  end
end
