#
# Cookbook:: ssh
# Recipe:: upload_keys
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:infrastructure][:ssh][:user]
group = node[:infrastructure][:ssh][:group]
files_in_folder = Dir["/var/chef/cache/cookbooks/ssh/files/*"]
ssh_keys = node[:application][:authentication][:ssh_keys]

# Recipes
ssh_keys.each do |key_file|
    if files_in_folder.include?("/var/chef/cache/cookbooks/ssh/files/#{key_file}")
        cookbook_file "Adding key file : #{key_file}" do
            source "#{key_file}"
            path "/home/#{user}/.ssh/#{key_file}"
            owner "#{user}"
            group "#{group}"
            mode 0400
            action :create_if_missing
        end
    end
end