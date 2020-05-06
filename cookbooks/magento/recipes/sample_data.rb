#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
group = node[:magento][:user]
web_root = node[:magento][:installation][:options][:directory]
composer_file = node[:magento][:composer_filename]

# Create var/composer_home directory
directory "Create composer_home directory" do
    path "#{web_root}/var/composer_home"
    owner "#{user}"
    group "#{group}"
    mode "0777"
    not_if { ::File.directory?("#{web_root}/var/composer_home") }
end

# Move auth.json into place
execute "Copy auth.json into place" do
    command "cp /home/#{user}/.#{composer_file}/auth.json #{web_root}/var/composer_home/"
end

# Include sample data
execute "Install sample data" do
    command "su #{user} -c '#{web_root}/bin/magento sampledata:deploy'"
end

# Update files/folders ownership
directories = ["var/", "pub/", "app/etc/", "generated/"]
directories.each do |directory|
    directory "Setting permissions for #{directory}" do
        path "#{web_root}/#{directory}"
        owner "#{user}"
        group "#{group}"
        mode '0777'
        recursive true
    end
end
