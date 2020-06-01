#
# Cookbook:: elasticsearch
# Recipe:: stop
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
if node[:elasticsearch][:use]
    service "elasticsearch" do
        action :stop
        only_if { ::File.directory?('/etc/elasticsearch') }
    end
end
