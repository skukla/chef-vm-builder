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
end
