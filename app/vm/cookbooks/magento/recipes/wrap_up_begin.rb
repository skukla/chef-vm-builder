# Cookbook:: magento
# Recipe:: wrap_up_begin
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

build_action = node[:magento][:build][:action]
restore_mode = node[:magento][:magento_restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
csc_options = node[:magento][:csc_options]

if %w[install force_install reinstall update_all update_app].include?(
     build_action,
   ) || merge_restore
  csc_options =
    csc_options.select do |key, hash|
      hash.is_a?(Hash) && !hash[:value].nil? && !hash[:value].empty?
    end
  cli_inserts = csc_options.select { |key, hash| hash[:insert_method] == 'cli' }
  queries = csc_options.select { |key, hash| hash[:insert_method] == 'query' }

  cli_inserts.each do |key, hash|
    magento_cli "Configuring Commerce Services Connector setting : #{key}" do
      action :config_set
      config_path hash[:config_path]
      config_value hash[:value]
      ignore_failure true
    end
  end

  queries.each do |key, hash|
    query =
      "INSERT INTO core_config_data (path, value) VALUES('#{hash[:config_path]}', '#{hash[:value]}') ON DUPLICATE KEY UPDATE path='#{hash[:config_path]}', value='#{hash[:value]}'"
    mysql "Inserting Commerce Services data : #{key}" do
      action :run_query
      db_query query
    end
  end
end
