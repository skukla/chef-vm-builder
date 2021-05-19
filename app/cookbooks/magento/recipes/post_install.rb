#
# Cookbook:: magento
# Recipe:: post_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
user = node[:magento][:init][:user]
build_action = node[:magento][:build][:action]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]
crontab = "/var/spool/cron/crontabs/#{user}"
first_run_flag = "#{web_root}/var/.first-run-state.flag"

if %w[install force_install reinstall update restore].include?(build_action)
  if apply_deploy_mode
    magento_app 'Set application mode' do
      action :set_application_mode
    end
  else
    magento_app 'Compile dependencies and deploy static content' do
      action %i[di_compile deploy_static_content]
    end
  end

  magento_app 'Enable cron' do
    action :enable_cron
    not_if { ::File.exist?(crontab) }
  end
end

if %w[install force_install reinstall restore].include?(build_action)
  magento_app 'Start consumers and set indexers to On Schedule mode' do
    action %i[start_consumers set_indexer_mode]
  end
end

magento_app 'Set first run flag' do
  action :set_first_run
  not_if { ::File.exist?(first_run_flag) }
end
