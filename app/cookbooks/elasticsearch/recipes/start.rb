#
# Cookbook:: elasticsearch
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
if node[:elasticsearch][:use]
    service "elasticsearch" do
        action :start
        only_if { ::File.directory?('/etc/elasticsearch') }
    end
end
