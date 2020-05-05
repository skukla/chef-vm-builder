#
# Cookbook:: magento
# Recipe:: uninstall_cron
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]

execute "Uninstall Magento crontab" do
    command "su #{user} -c 'crontab -r'"
    only_if "su #{user} -c 'crontab -l'"
end
