#
# Cookbook:: composer
# Recipe:: install
#
# Copyright:: 2020, Steve, All Rights Reserved.
user = node[:composer][:user]
group = node[:composer][:user]
timeout = node[:composer][:timeout]

# Create composer configuration directory
directory "#{user} composer configuration directory" do
  path "/home/#{user}/.composer"
  owner "#{user}"
  group "#{group}"
  mode "775"
  not_if { ::File.directory?("/home/#{user}/.composer") }
end

# Define composer config
template 'Composer configuration' do
  source 'config.json.erb'
  path "/home/#{user}/.composer/config.json"
  owner "#{user}"
  group "#{group}"
  mode "644"
  variables({
    timeout: "#{timeout}"
  })
end
