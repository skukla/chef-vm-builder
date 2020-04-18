#
# Cookbook:: mysql
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes

# Define, enable, and start the MySQL service
service 'mysql' do
    action [:start]
end
