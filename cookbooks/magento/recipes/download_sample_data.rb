#
# Cookbook:: magento
# Recipe:: download_sample_data
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

# Set auth.json ownership
file "Set auth.json permissions" do
    path "#{web_root}/var/composer_home/auth.json"
    owner "#{user}"
    group "#{group}"
    mode "0777"
    only_if { ::File.exist?("#{web_root}/var/composer_home/auth.json") }
end

# Include sample data
execute "Install sample data" do
    command "su #{user} -c '#{web_root}/bin/magento sampledata:deploy'"
end

# Update folder ownership
directories = ["var/", "pub/", "app/etc/", "generated/"]
directories.each do |directory|
    execute "Update #{directory} permissions" do
        command "sudo chown -R #{user}:#{group} #{web_root}/#{directory} && sudo chmod -R 777 #{web_root}/#{directory}"
    end
end