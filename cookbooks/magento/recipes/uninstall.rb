#
# Cookbook:: magento
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:application][:webserver][:web_root]
db_name = node[:infrastructure][:database][:name]
db_root_password = node[:application][:database][:root_password]

# Recipes
directory "Remove the web root" do
    path "#{web_root}"
    recursive true
    action :delete
end

directory "Re-create the web root" do
    path "#{web_root}"
    owner "#{user}"
    group "#{group}"
    mode '755'
    not_if { ::File.directory?("#{web_root}") }
end

ruby_block "Delete the Magento database" do
    block do
        %x[mysql -uroot -e "DROP DATABASE IF EXISTS #{db_name};"]
    end
    action :create
end
