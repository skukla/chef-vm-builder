# Cookbook:: magento
# Recipe:: post_install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]
deploy_mode = node[:magento][:build][:deploy_mode][:mode]
first_run_flag = "#{web_root}/var/.first-run-state.flag"

if %w[install force_install reinstall update_all update_app restore].include?(
		build_action,
   )
	if apply_deploy_mode && %w[production developer].include?(deploy_mode)
		magento_cli "Set application mode to #{deploy_mode}" do
			action :set_application_mode
			deploy_mode deploy_mode
		end
	end

	if apply_deploy_mode && deploy_mode == 'developer'
		magento_cli 'Compile dependencies and deploy static content' do
			action %i[di_compile deploy_static_content]
		end
	end

	magento_app 'Set first run flag' do
		action :set_first_run
		not_if { ::File.exist?(first_run_flag) }
	end
end
