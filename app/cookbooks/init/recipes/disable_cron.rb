#
# Cookbook:: init
# Recipe:: disable_cron
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:init][:magento][:build_action]

magento_app 'Disable cron' do
  action :disable_cron
  only_if do
    ::File.exist?("/var/spool/cron/crontabs/#{user}") &&
      build_action != 'install'
  end
end
