#
# Cookbook:: mysql
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
service 'mysql' do
    action [:restart]
end
