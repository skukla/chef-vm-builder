#
# Cookbook:: magento_custom_modules
# Resource:: custom_module_data
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :custom_module_data
provides :custom_module_data

property :build_action,         String, default: node[:magento_custom_modules][:magento][:build_action]
property :data_type,            String
property :data,                 Hash

action :process do
  unless new_resource.data.nil?
    if new_resource.data_type == 'data_packs'
      title_string = 'remote data packs'
      module_list = ModuleListHelper.get_remote_data_packs(new_resource.data)
    else
      title_string = 'custom modules'
      module_list = ModuleListHelper.get_remote_custom_modules(new_resource.data)
    end

    unless module_list.empty?
      module_list.each do |_key, data|
        next if data[:repository_url].nil?

        composer "Adding remote repository: #{data[:module_name]}" do
          action :add_repository
          module_name data[:module_name]
          repository_url data[:repository_url]
          not_if do
            new_resource.build_action == 'reinstall' ||
              (::File.exist?("#{web_root}/var/.first-run-state.flag") && new_resource.build_action == 'install')
          end
        end
      end

      unless ModuleListHelper.build_require_string(module_list).empty?
        composer "Adding #{title_string}: #{ModuleListHelper.build_require_string(module_list)}" do
          action :require
          package_name ModuleListHelper.build_require_string(module_list)
          options ['no-update']
          not_if do
            new_resource.build_action == 'reinstall' ||
              (::File.exist?("#{web_root}/var/.first-run-state.flag") && new_resource.build_action == 'install')
          end
        end
      end
    end
  end
end
