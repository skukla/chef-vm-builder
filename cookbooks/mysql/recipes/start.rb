#
# Cookbook:: mysql
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes

# (Re)start the MySQL service
service 'mysql' do
    action [:restart]
end
