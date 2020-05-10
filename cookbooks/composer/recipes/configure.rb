#
# Cookbook:: composer
# Recipe:: configure
#
# Copyright:: 2020, Steve, All Rights Reserved.
composer "run" do
  timeout node[:composer][:timeout]
  action :configure
end

composer "run" do
  action :clearcache
  only_if { node[:composer][:clear_composer_cache] }
end