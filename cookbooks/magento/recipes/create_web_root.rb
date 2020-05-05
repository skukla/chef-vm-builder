#
# Cookbook:: magento
# Recipe:: create_web_root
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
group = node[:magento][:user]
web_root = node[:magento][:installation][:options][:directory]

# Create the web root
directory 'Web root directory' do
    path "#{web_root}"
    owner "#{user}"
    group "#{group}"
    mode '0770'
    recursive true
    not_if { ::File.directory?("#{web_root}") }
end

execute "Set permissions" do
    command "chown -R #{user}:#{group} #{web_root}"
    only_if { ::File.directory?("#{web_root}") }
end

execute "Set setgid on webroot" do
    command "chmod g+s #{web_root}"
    only_if { ::File.directory?("#{web_root}") }
end