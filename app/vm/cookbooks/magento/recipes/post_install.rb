# Cookbook:: magento
# Recipe:: post_install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

build_action = node[:magento][:build][:action]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]
deploy_mode = node[:magento][:build][:deploy_mode][:mode]
backup_holding_area = node[:magento_restore][:holding_area]
restore_mode = node[:magento][:magento_restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
provider = node[:magento][:init][:provider]
search_engine_type = node[:magento][:search_engine][:type]
elasticsearch_host = node[:magento][:search_engine][:host][:value]

if build_action == 'restore'
  magento_restore 'Restore database' do
    action :restore_database
    source_path backup_holding_area
    pattern %w[*_db.sql]
  end

  if search_engine_type == 'elasticsearch'
    magento_cli 'Resetting elasticsearch host' do
      action :config_set
      config_path 'catalog/search/elasticsearch7_server_hostname'
      config_value elasticsearch_host
    end
  end

  magento_restore 'Clean up backup files' do
    action :remove_backup_files
    source_path backup_holding_area
  end
end

if %w[restore reinstall].include?(build_action)
  ruby_block 'Removing old cookies from the database' do
    block do
      DatabaseHelper.execute_query(
        "DELETE FROM core_config_data WHERE path LIKE '%web/cookie%'",
        DatabaseHelper.db_name,
      )
      pp 'Deleted cookie records from the database'
    end
  end

  if VersionHelper.is_requested_newer?('2.4.5', MagentoHelper.base_version)
    magento_cli 'Setting admin session time' do
      action :config_set
      config_path 'system/security/max_session_size_admin'
      config_value '2560000'
    end
  end
end

if (
     %w[install force_install reinstall update_all update_app].include?(
       build_action,
     ) || merge_restore
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

if search_engine_type == 'live_search' && provider.include?('vmware')
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
