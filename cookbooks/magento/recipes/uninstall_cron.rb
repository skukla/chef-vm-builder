#
# Cookbook:: magento
# Recipe:: uninstall_cron
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
db_name = node[:infrastructure][:database][:name]

execute "Uninstall Magento crontab" do
    command "su #{user} -c 'crontab -r'"
    only_if "su #{user} -c 'crontab -l'"
end

ruby_block "Clear the cron schedule table" do
    block do
        %x[mysql -uroot -e "USE #{db_name};DELETE FROM cron_schedule;"]
    end
    action :create
end
