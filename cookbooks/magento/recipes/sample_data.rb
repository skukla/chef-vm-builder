#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:application][:webserver][:web_root]
composer_file = node[:application][:composer][:filename]

# Create var/composer_home directory
directory "Create composer_home directory" do
    path "#{web_root}/var/composer_home"
    owner "#{user}"
    group "#{group}"
    mode "777"
    not_if { ::File.directory?("#{web_root}/var/composer_home") }
end

# Move auth.json into place
execute "Move auth.json into place" do
    command "cp /home/#{user}/.#{composer_file}/auth.json #{web_root}/var/composer_home/"
end

# Include sample data
execute "Install sample data" do
    command "cd #{web_root} && su #{user} -c './bin/magento sampledata:deploy'"
end
