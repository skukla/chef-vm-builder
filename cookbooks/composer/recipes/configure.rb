#
# Cookbook:: composer
# Recipe:: install
#
# Copyright:: 2020, Steve, All Rights Reserved.

# Attributes
user = node[:infrastructure][:composer][:user]
group = node[:infrastructure][:composer][:group]
timeout = node[:infrastructure][:composer][:timeout]

# Create composer configuration directory
directory "#{user} composer configuration directory" do
  path "/home/#{user}/.composer"
  owner "#{user}"
  group "#{group}"
  mode '755'
  not_if { ::File.directory?("/home/#{user}/.composer") }
end

# Define composer config
template 'Composer configuration' do
  source 'config.json.erb'
  path "/home/#{user}/.composer/config.json"
  owner "#{user}"
  group "#{group}"
  mode '644'
  variables({
    timeout: "#{timeout}"
  })
end
