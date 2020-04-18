#
# Cookbook:: magento
# Recipe:: uninstall_app
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
db_name = node[:infrastructure][:database][:name]

directory "Remove the web root" do
    path "#{web_root}"
    recursive true
    only_if { ::File.directory?("#{web_root}") }
    action :delete
end

ruby_block "Delete the Magento database" do
    block do
        %x[mysql -uroot -e "DROP DATABASE IF EXISTS #{db_name};"]
    end
    action :create
end
