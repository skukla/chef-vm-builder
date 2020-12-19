#
# Cookbook:: magento_demo_builder
# Resource:: magento_demo_builder
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_demo_builder
provides :magento_demo_builder

property :name,                             String, name_property: true
property :user,                             String, default: node[:magento_demo_builder][:init][:user]
property :group,                            String, default: node[:magento_demo_builder][:init][:user]
property :web_root,                         String, default: node[:magento_demo_builder][:init][:web_root]
property :db_user,                          String, default: node[:magento_demo_builder][:mysql][:db_user]
property :db_password,                      String, default: node[:magento_demo_builder][:mysql][:db_password]
property :db_name,                          String, default: node[:magento_demo_builder][:mysql][:db_name]
property :chef_files_path,                  String, default: node[:magento_demo_builder][:chef_files][:path]
property :data_pack_vendor,                 String, default: node[:magento_demo_builder][:data_pack][:vendor]
property :data_pack_file_list,              Array,  default: node[:magento_demo_builder][:data_pack][:files]
property :custom_module_list,               Hash,   default: node[:magento_demo_builder][:custom_modules]
property :data_pack_data,                   Hash

action :remove_data_patches do
  Dir["#{new_resource.chef_files_path}/*"].each do |entry|
    entry_path = [::File.dirname(entry), ::File.basename(entry)].join('/').split('/').pop(1).join
    module_type = if new_resource.data_pack_data[:value]['repository_url'] == entry_path
                    'local'
                  else
                    'remote'
                  end

    module_name_data = StringReplaceHelper.prepare_module_names(
      new_resource.data_pack_data[:value]['name'],
      new_resource.data_pack_vendor,
      new_resource.data_pack_data[:value]['repository_url'],
      module_type
    )

    vendor_name = module_name_data[:vendor_name]
    module_name = module_name_data[:module_name]
    vendor_string = module_name_data[:vendor_string]
    source = "#{new_resource.web_root}/app/code/#{vendor_name}/#{module_name}/fixtures"

    ruby_block "Remove existing data patch for #{vendor_name}" do
      block do
        DatabaseHelper.remove_data_patch(vendor_string)
      end
      only_if do
        Dir.exist?(source) ||
          DatabaseHelper.patch_exists(vendor_string)
      end
    end
  end
end

action :build_local_data_packs do
  unless new_resource.data_pack_data[:value]['repository_url'].nil?
    Dir["#{new_resource.chef_files_path}/*"].each do |entry|
      entry_path = [::File.dirname(entry), ::File.basename(entry)].join('/').split('/').pop(1).join
      next unless new_resource.data_pack_data[:value]['repository_url'] == entry_path

      module_name_data = StringReplaceHelper.prepare_module_names(
        new_resource.data_pack_data[:value]['name'],
        new_resource.data_pack_vendor,
        new_resource.data_pack_data[:value]['repository_url'],
        'local'
      )

      package_name = module_name_data[:package_name]
      vendor_name = module_name_data[:vendor_name]
      module_name = module_name_data[:module_name]
      vendor_string = module_name_data[:vendor_string]
      module_string = module_name_data[:module_string]
      [
        'app',
        'app/code',
        "app/code/#{vendor_string}",
        "app/code/#{vendor_string}/#{module_string}",
        "app/code/#{vendor_string}/#{module_string}/media",
        "app/code/#{vendor_string}/#{module_string}/fixtures",
        "app/code/#{vendor_string}/#{module_string}/etc",
        "app/code/#{vendor_string}/#{module_string}/Setup",
        "app/code/#{vendor_string}/#{module_string}/Setup/Patch",
        "app/code/#{vendor_string}/#{module_string}/Setup/Patch/Data"
      ].each do |dir|
        directory "Creating #{dir}" do
          path "#{new_resource.web_root}/#{dir}"
          owner new_resource.user
          group new_resource.group
          only_if { Dir.exist?("#{new_resource.chef_files_path}/#{new_resource.data_pack_data[:value]['repository_url']}") }
        end
      end
      new_resource.data_pack_file_list.each do |file_data|
        template "Creating #{file_data[:source]}" do
          source "#{file_data[:source]}.erb"
          path "#{new_resource.web_root}/app/code/#{vendor_string}/#{module_string}/#{file_data[:path]}/#{file_data[:source]}"
          owner new_resource.user
          group new_resource.group
          mode file_data[:mode]
          variables({
                      package_name: package_name,
                      module_name: module_name,
                      vendor_name: vendor_name,
                      vendor_string: vendor_string,
                      module_string: module_string
                    })
          only_if do
            Dir.exist?("#{new_resource.chef_files_path}/#{new_resource.data_pack_data[:value]['repository_url']}") &&
              Dir.exist?("#{new_resource.web_root}/app/code/#{vendor_string}/#{module_string}")
          end
        end
      end
    end
  end
end

action :install_local_data_pack_content do
  Dir["#{new_resource.chef_files_path}/*"].each do |entry|
    entry_path = [::File.dirname(entry), ::File.basename(entry)].join('/').split('/').pop(1).join
    next unless new_resource.data_pack_data[:value]['repository_url'] == entry_path

    module_name_data = StringReplaceHelper.prepare_module_names(
      new_resource.data_pack_data[:value]['name'],
      new_resource.data_pack_vendor,
      new_resource.data_pack_data[:value]['repository_url'],
      'local'
    )

    vendor_name = module_name_data[:vendor_name]
    module_name = module_name_data[:module_name]
    vendor_string = module_name_data[:vendor_string]
    module_string = module_name_data[:module_string]

    %w[data media].each do |media_type|
      unless Dir.exist?("#{new_resource.chef_files_path}/#{new_resource.data_pack_data[:value]['repository_url']}/#{media_type}")
        next
      end

      dest_path = media_type == 'data' ? 'fixtures' : media_type
      remote_directory "Adding #{media_type} files to #{vendor_name}/#{module_name}" do
        source "#{new_resource.data_pack_data[:value]['repository_url']}/#{media_type}"
        path "#{new_resource.web_root}/app/code/#{vendor_string}/#{module_string}/#{dest_path}"
        owner new_resource.user
        group new_resource.group
        files_owner new_resource.user
        files_group new_resource.group
        action :create_if_missing
        recursive false
        overwrite true
      end
      next unless media_type == 'media'

      remote_directory "#{module_name.downcase} media" do
        source "#{new_resource.data_pack_data[:value]['repository_url']}/#{media_type}"
        path "#{new_resource.web_root}/app/code/#{vendor_string}/#{module_string}/#{media_type}"
        owner new_resource.user
        group new_resource.group
        files_owner new_resource.user
        files_group new_resource.group
        action :create_if_missing
        recursive false
        overwrite true
      end
      module_full_path = "#{new_resource.web_root}/#{vendor_string}/#{module_string}"
      template_manager_src = 'template_manager'
      template_manager_dest = '.template-manager'

      ruby_block "Copying files from #{template_manager_src} to #{template_manager_dest}" do
        block do
          Dir["#{module_full_path}/#{media_type}/#{template_manager_src}/*"].each do |file|
            FileUtils.cp(file, file.sub(template_manager_src, template_manager_dest))
          end
          FileUtils.rm_rf("#{module_full_path}/#{media_type}/#{template_manager_src}")
        end
        only_if do
          Dir.exist?("#{module_full_path}/#{media_type}/#{template_manager_src}") &&
            !Dir.empty?("#{module_full_path}/#{media_type}/#{template_manager_src}") &&
            Dir.exist?("#{module_full_path}/#{media_type}/#{template_manager_dest}")
        end
      end
    end
  end
end

action :clean_up_data_packs do
  Dir["#{new_resource.chef_files_path}/*"].each do |entry|
    entry_path = [::File.dirname(entry), ::File.basename(entry)].join('/').split('/').pop(1).join
    if new_resource.data_pack_data[:value]['repository_url'] == entry_path
      module_type = 'local'
      module_path = 'app/code'
    else
      module_type = 'remote'
      module_path = 'vendor'
    end

    module_name_data = StringReplaceHelper.prepare_module_names(
      new_resource.data_pack_data[:value]['name'],
      new_resource.data_pack_vendor,
      new_resource.data_pack_data[:value]['repository_url'],
      module_type
    )

    # vendor_name = module_name_data[:vendor_name]
    module_name = module_name_data[:module_name]
    vendor_string = module_name_data[:vendor_string]
    module_string = module_name_data[:module_string]

    ruby_block "Remove unwanted hidden files from remote data pack #{module_name}" do
      block do
        ModuleListHelper.clean_up_module_data("#{new_resource.web_root}/#{module_path}/#{vendor_string}/#{module_string}")
      end
      only_if { ::Dir.exist?("#{new_resource.web_root}/#{module_path}/#{vendor_string}/#{module_string}") }
    end
  end
end
