#
# Cookbook:: mysql
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
mysql 'Install, configure, and enable MySQL' do
	action %i[install configure enable]
end

mysql 'Restart Mysql' do
	action :restart
end
