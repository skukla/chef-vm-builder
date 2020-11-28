#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
version = node[:magento][:options][:version]
family = node[:magento][:options][:family]
build_action = node[:magento][:build][:action]
sample_data = node[:magento][:build][:sample_data]
custom_module_list = node[:magento][:custom_modules]
data_packs_list = node[:magento][:data_packs]
apply_patches = node[:magento][:patches][:apply]
use_elasticsearch = node[:magento][:elasticsearch][:use]

composer "Create Magento #{family.capitalize} #{version} project" do
  action :create_project
  repository_url 'https://repo.magento.com/'
  options ['no-install']
  package_version version.to_s
  project_name "magento/project-#{family}-edition"
  project_directory web_root.to_s
  only_if do
    ::Dir.empty?(web_root.to_s) &&
      %w[install force_install].include?(build_action)
  end
end

composer 'Set the project stability setting' do
  action :set_project_stability
  only_if do
    ::File.exist?("#{web_root}/composer.json")
  end
  not_if do
    ::File.exist?("#{web_root}/var/.first-run-state.flag") &&
      (build_action == 'install' || build_action != 'reinstall')
  end
end

composer 'Update the project sort-packages setting' do
  action :update_sort_packages
  only_if do
    ::File.exist?("#{web_root}/composer.json")
  end
  not_if do
    ::File.exist?("#{web_root}/var/.first-run-state.flag") &&
      (build_action == 'install' || build_action != 'reinstall')
  end
end

magento_app 'Update the Magento version' do
  action :update_version
  only_if do
    ::File.exist?("#{web_root}/composer.json") &&
      ::File.foreach("#{web_root}/composer.json").grep(/#{version}/).none? &&
      build_action == 'update'
  end
end

magento_app 'Remove outdated modules' do
  action :remove_modules
  not_if do
    ::File.foreach("#{web_root}/composer.json").grep(/replace/).any? ||
      (::File.exist?("#{web_root}/var/.first-run-state.flag") && %w[install force_install install force_install install reinstall].include?(build_action))
  end
end

composer 'Require the B2B modules' do
  action :require
  package_name 'magento/extension-b2b'
  package_version '^1.0'
  options ['no-update']
  not_if do
    ::File.foreach("#{web_root}/composer.json").grep(/extension-b2b/).any? ||
      (::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install')
  end
  only_if do
    family == 'enterprise' &&
      ::File.exist?("#{web_root}/composer.json")
  end
end

unless data_packs_list.empty?
  data_packs_list.each do |_data_pack_key, data_pack_data|
    custom_module "Add #{data_pack_data[:module_name]}" do
      action :download
      package_name (data_pack_data[:package_name]).to_s
      module_name (data_pack_data[:module_name]).to_s
      package_version (data_pack_data[:package_version]).to_s
      repository_url (data_pack_data[:repository_url]).to_s
      options ['no-update']
      not_if do
        build_action == 'reinstall' ||
          (::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install')
      end
    end
  end
end

unless custom_module_list.empty?
  custom_module_list.each do |_custom_module_key, custom_module_data|
    custom_module "Add #{custom_module_data[:module_name]}" do
      action :download
      package_name (custom_module_data[:package_name]).to_s
      module_name (custom_module_data[:module_name]).to_s
      package_version (custom_module_data[:package_version]).to_s
      repository_url (custom_module_data[:repository_url]).to_s
      options ['no-update']
      not_if do
        build_action == 'reinstall' ||
          (::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install') ||
          (!use_elasticsearch && custom_module_data[:module_name].include?('elasticsuite'))
      end
    end
  end
end

if apply_patches && (%w[force_install update].include?(build_action) || (apply_patches && build_action == 'install' && !::File.exist?("#{web_root}/var/.first-run-state.flag")))
  include_recipe 'magento_patches::default'
end

magento_app 'Download the codebase' do
  action :download
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != 'force_install' }
  only_if do
    !::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' ||
      build_action == 'force_install'
  end
end

magento_app 'Update the codebase' do
  action :update
  only_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'update' }
end

magento_app 'Add sample data' do
  action :add_sample_data
  not_if do
    ::File.exist?("#{web_root}/var/.sample-data-state.flag") ||
      !sample_data
  end
end

if apply_patches && (%w[force_install update].include?(build_action) || (apply_patches && build_action == 'install' && !::File.exist?("#{web_root}/var/.first-run-state.flag")))
  include_recipe 'magento_patches::apply'
end

samba 'Create samba drop directories' do
  action :create_magento_shares
end

magento_app 'Set permissions after downloading code' do
  action :set_permissions
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end
