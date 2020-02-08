#
# Cookbook:: composer
# Recipe:: install
#
# Copyright:: 2020, Steve, All Rights Reserved.

# Attributes
user = node[:infrastructure][:composer][:user]
group = node[:infrastructure][:composer][:group]
timeout = node[:infrastructure][:composer][:timeout]

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
