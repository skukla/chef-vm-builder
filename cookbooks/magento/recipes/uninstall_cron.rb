#
# Cookbook:: magento
# Recipe:: uninstall_cron
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]

execute "Uninstall Magento crontab" do
    command "su #{user} -c 'crontab -r'"
    only_if "su #{user} -c 'crontab -l'"
end
