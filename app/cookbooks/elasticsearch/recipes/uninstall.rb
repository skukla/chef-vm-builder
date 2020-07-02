#
# Cookbook:: elasticsearch
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
elasticsearch "Stop and uninstall Elasticsearch" do
    action [:stop, :uninstall]
end

java "Uninstall Java" do
    action :uninstall
end