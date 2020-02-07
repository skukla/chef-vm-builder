#
# Cookbook:: elasticsearch
# Recipe:: uninstall_java
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes

# Remove Java packages
execute "Uninstall Java" do
    command "sudo apt-get purge --auto-remove openjdk* -y"
    only_if "which java"
end
