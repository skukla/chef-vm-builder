#
# Cookbook:: composer
# Recipe:: install
#
# Copyright:: 2020, Steve, All Rights Reserved.
composer "run" do
  action :download
end

composer "run" do
  action :install_app
end