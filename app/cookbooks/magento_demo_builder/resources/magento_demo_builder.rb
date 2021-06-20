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
property :data_pack_data,                   Hash

action :build_local_data_pack do
  unless new_resource.data_pack_data[:value]['repository_url'].nil?
    Dir["#{new_resource.chef_files_path}/*"].each do |entry|
      entry_path = [::File.dirname(entry), ::File.basename(entry)].join('/').split('/').pop(1).join
      next unless new_resource.data_pack_data[:value]['repository_url'] == entry_path

      module_name_data = StringReplaceHelper.prepare_module_names(
        new_resource.data_pack_data[:value]['package_name'],
        new_resource.data_pack_vendor,
        new_resource.data_pack_data[:value]['repository_url'],
        'local'
      )

      package_name = module_name_data[:package_name]
      vendor_name = module_name_data[:vendor_name]
      module_name = module_name_data[:module_name]
      vendor_string = module_name_data[:vendor_string]
      module_string = module_name_data[:module_string]
      module_path = 'app/code'

      execute 'Clearing fixtures' do
        command "rm -rf #{new_resource.web_root}/#{module_path}/#{vendor_string}/#{module_string}/fixtures/*"
      end

      [
        'app',
        module_path.to_s,
        "#{module_path}/#{vendor_string}",
        "#{module_path}/#{vendor_string}/#{module_string}",
        "#{module_path}/#{vendor_string}/#{module_string}/media",
        "#{module_path}/#{vendor_string}/#{module_string}/data",
        "#{module_path}/#{vendor_string}/#{module_string}/etc"
      ].each do |dir|
        directory "Creating #{dir}" do
          path "#{new_resource.web_root}/#{dir}"
          owner new_resource.user
          group new_resource.group
          only_if do
            Dir.exist?("#{new_resource.chef_files_path}/#{new_resource.data_pack_data[:value]['repository_url']}")
          end
        end
      end
      new_resource.data_pack_file_list.each do |file_data|
        template "Creating #{file_data[:source]}" do
          source "#{file_data[:source]}.erb"
          path "#{new_resource.web_root}/#{module_path}/#{vendor_string}/#{module_string}/#{file_data[:path]}/#{file_data[:source]}"
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
              Dir.exist?("#{new_resource.web_root}/#{module_path}/#{vendor_string}/#{module_string}")
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
      new_resource.data_pack_data[:value]['package_name'],
      new_resource.data_pack_vendor,
      new_resource.data_pack_data[:value]['repository_url'],
      'local'
    )

    vendor_name = module_name_data[:vendor_name]
    module_name = module_name_data[:module_name]
    vendor_string = module_name_data[:vendor_string]
    module_string = module_name_data[:module_string]
    module_path = 'app/code'

    %w[data media].each do |media_type|
      unless Dir.exist?("#{new_resource.chef_files_path}/#{new_resource.data_pack_data[:value]['repository_url']}/#{media_type}")
        next
      end

      remote_directory "Adding #{media_type} files to #{vendor_name}/#{module_name}" do
        source "#{new_resource.data_pack_data[:value]['repository_url']}/#{media_type}"
        path "#{new_resource.web_root}/#{module_path}/#{vendor_string}/#{module_string}/#{media_type}"
        owner new_resource.user
        group new_resource.group
        files_owner new_resource.user
        files_group new_resource.group
        action :create
        recursive false
        overwrite true
      end
      next unless media_type == 'media'

      remote_directory "#{module_name.downcase} media" do
        source "#{new_resource.data_pack_data[:value]['repository_url']}/#{media_type}"
        path "#{new_resource.web_root}/#{module_path}/#{vendor_string}/#{module_string}/#{media_type}"
        owner new_resource.user
        group new_resource.group
        files_owner new_resource.user
        files_group new_resource.group
        action :create
        recursive false
        overwrite true
      end
    end
  end
end

action :clean_up_data_pack do
  module_name_data = StringReplaceHelper.prepare_module_names(
    new_resource.data_pack_data[:value]['package_name'],
    new_resource.data_pack_vendor,
    new_resource.data_pack_data[:value]['repository_url'],
    !new_resource.data_pack_data[:value]['repository_url'].include?('github') ? 'local' : 'remote'
  )

  if !new_resource.data_pack_data[:value]['repository_url'].include?('github')
    module_path = 'app/code'
    full_path = "#{module_name_data[:vendor_string]}/#{module_name_data[:module_string]}"
  else
    module_path = 'vendor'
    full_path = "#{module_name_data[:vendor_name]}/#{module_name_data[:module_name]}"
  end

  ruby_block "Remove unwanted hidden files from #{module_name_data[:module_name]} data pack" do
    block do
      ModuleListHelper.clean_up_module_data("#{new_resource.web_root}/#{module_path}/#{full_path}")
    end
    only_if { ::Dir.exist?("#{new_resource.web_root}/#{module_path}/#{full_path}") }
  end
end

action :install_data_pack do
  module_name_data = StringReplaceHelper.prepare_module_names(
    new_resource.data_pack_data[:value]['package_name'],
    new_resource.data_pack_vendor,
    new_resource.data_pack_data[:value]['repository_url'],
    !new_resource.data_pack_data[:value]['repository_url'].include?('github') ? 'local' : 'remote'
  )

  vendor_string = module_name_data[:vendor_string]
  module_string = module_name_data[:module_string]

  magento_cli "Installing the #{module_string} data pack" do
    action :run
    command_list "gxd:datainstall #{vendor_string}_#{module_string} -r"
  end
end
