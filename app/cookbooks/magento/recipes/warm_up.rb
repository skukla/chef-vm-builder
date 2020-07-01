#
# Cookbook:: magento
# Recipe:: warm_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
mysql "Start the database" do
    action :start
end