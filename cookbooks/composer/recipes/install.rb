#
# Cookbook:: composer
# Recipe:: install
#
# Copyright:: 2020, Steve, All Rights Reserved.
composer "Download composer application" do
    action :download_app
end

composer "Install composer application" do
    action :install_app
end