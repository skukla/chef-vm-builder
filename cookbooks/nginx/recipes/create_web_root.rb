#
# Cookbook:: nginx
# Recipe:: create_web_root
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:nginx][:user]
group = node[:nginx][:user]
web_root = node[:nginx][:web_root]

# Create the web root
directory 'Web root directory' do
    path "#{web_root}"
    owner "#{user}"
    group "#{group}"
    mode '0770'
    recursive true
    not_if { ::File.directory?("#{web_root}") }
end

execute "Set setgid on webroot" do
    command "chmod g+s #{web_root}"
    only_if { ::File.directory?("#{web_root}") }
end