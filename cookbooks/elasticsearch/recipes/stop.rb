#
# Cookbook:: elasticsearch
# Recipe:: stop
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]

if use_elasticsearch
    service 'elasticsearch' do
        action [:stop]
        only_if { ::File.directory?('/etc/elasticsearch') }
    end
end
