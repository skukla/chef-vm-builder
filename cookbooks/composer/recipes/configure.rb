#
# Cookbook:: composer
# Recipe:: configure
#
# Copyright:: 2020, Steve, All Rights Reserved.
web_root = node[:composer][:web_root]
timeout = node[:composer][:timeout]
clearcache = node[:composer][:clear_composer_cache]

composer "Set composer timeout" do
  timeout timeout
  action :configure_app
end

composer "Clear composer cache" do
  action :clearcache
  only_if { Dir.exist?("#{web_root}") && clearcache }
end

