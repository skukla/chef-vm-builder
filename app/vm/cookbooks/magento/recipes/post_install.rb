# Cookbook:: magento
# Recipe:: post_install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]
deploy_mode = node[:magento][:build][:deploy_mode][:mode]
backup_holding_area = node[:magento_restore][:holding_area]
restore_mode = node[:magento][:magento_restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
search_engine_type = node[:magento][:search_engine][:type]
es_module_list = node[:magento][:search_engine][:elasticsearch][:module_list]
ls_module_list = node[:magento][:search_engine][:live_search][:module_list]
hypervisor = node[:magento][:init][:hypervisor]

if build_action == 'restore'
	magento_restore 'Restore database' do
		action :restore_database
		source_path backup_holding_area
		pattern %w[*_db.sql]
	end

	magento_restore 'Clean up backup files' do
		action :remove_backup_files
		source_path backup_holding_area
	end
end

if (
		%w[install force_install update_all update_app].include?(build_action) ||
			merge_restore
   )
	ruby_block 'Setting search modules' do
		block { MagentoHelper.switch_search_modules }
		only_if { ::File.exist?(MagentoHelper.config_php) }
	end
end

if %w[update_all update_app].include?(build_action) || merge_restore
	magento_cli 'Reset indexers and upgrade the database' do
		action %i[reset_indexers db_upgrade]
	end
end

if search_engine_type == 'live_search' && hypervisor.include?('vmware')
	elasticsearch 'Stopping and disabling elasticsearch' do
		action %i[stop disable]
	end
end

if %w[install force_install reinstall update_all update_app restore].include?(
		build_action,
   )
	magento_app 'Set permissions after installation or database upgrade' do
		action :set_permissions
	end
end

if %w[install force_install reinstall update_all update_app restore].include?(
		build_action,
   )
	if apply_deploy_mode
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
end
