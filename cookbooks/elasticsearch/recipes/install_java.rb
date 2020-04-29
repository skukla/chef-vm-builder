#
# Cookbook:: elasticsearch
# Recipe:: install_java
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
apt_package 'default-jdk' do
    action :install
    not_if "which java"
end

