#
# Cookbook:: elasticsearch
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]

if use_elasticsearch
    service 'elasticsearch' do
        action :start
        only_if { ::File.directory?('/etc/elasticsearch') }
    end
end
