#
# Cookbook:: magento
# Recipe:: clear_cron_schedule
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
db_name = node[:magento][:database][:name]

ruby_block "Clear the cron schedule table" do
    block do
        %x[mysql -uroot -e "USE #{db_name};DELETE FROM cron_schedule;"]
    end
    action :create
    only_if "su #{user} -c 'crontab -l'"
end
