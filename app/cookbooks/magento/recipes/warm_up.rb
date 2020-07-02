#
# Cookbook:: magento
# Recipe:: warm_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
mysql "Restart Mysql" do
    action :restart
end

mailhog "Restart Mailhog" do
    action :restart
end

samba "Restart Samba" do
    action :restart
end

nginx "Restart Nginx" do
    action :restart
end

elasticsearch "Restart Elasticsearch" do
    action :restart
end