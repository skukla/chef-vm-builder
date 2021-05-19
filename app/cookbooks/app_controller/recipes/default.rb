#
# Cookbook:: app_controller
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:app_controller][:init][:magento][:build_action]
web_root = node[:app_controller][:init][:web_root]
first_run_flag = "#{web_root}/var/.first-run-state.flag"
first_run_install = !::File.exist?(first_run_flag) && build_action == 'install'
after_first_run_install = ::File.exist?(first_run_flag) && build_action == 'install'

if %w[reinstall update refresh].include?(build_action) && (!::Dir.exist?(web_root) || ::Dir.empty?(web_root))
  raise "You're using an #{build_action} build action but Magento hasn't been installed yet.
  Use install, force_install or restore from a backup first."
end

if after_first_run_install
  raise "You've already built a VM but you're still using an install build action.
  Try another instead."
end

if build_action == 'install' && (::Dir.exist?(web_root) && !::Dir.empty?(web_root))
  raise "Looks like your first build may have been
  interrupted. Use a force_install build action to rebuild the VM."
end

include_recipe 'init::disable_cron'
if %w[install force_install restore].include?(build_action)
  include_recipe 'app_controller::base'
  include_recipe 'app_controller::infrastructure'
end
include_recipe 'app_controller::application' if first_run_install || !after_first_run_install
