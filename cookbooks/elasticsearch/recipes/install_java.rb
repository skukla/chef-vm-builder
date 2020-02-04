#
# Cookbook:: elasticsearch
# Recipe:: install_java
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]

# Install Java
if use_elasticsearch
    apt_package 'default-jdk' do
        action :install
        not_if "which java"
    end
else
    service 'elasticsearch' do
        action [:stop]
        only_if "jps | grep Elasticsearch"
    end
    
    execute "Uninstall Java" do
        command "sudo apt-get purge --auto-remove openjdk* -y"
        only_if "which java"
    end
end
