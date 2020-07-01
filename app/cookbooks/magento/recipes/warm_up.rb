#
# Cookbook:: magento
# Recipe:: warm_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
mysql "Restart mysql" do
    action :restart
end

mailhog "Restart mailhog" do
    action :restart
end

samba "Restart samba" do
    action :restart
end