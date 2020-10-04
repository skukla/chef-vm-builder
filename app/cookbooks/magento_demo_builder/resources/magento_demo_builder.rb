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
property :patch_class,                      String, default: node[:magento_demo_builder][:demo_shell][:patch_class]
property :patches_holding_area,             String, default: node[:magento_demo_builder][:magento_patches][:holding_area]
property :demo_shell_path,                  String, default: node[:magento_demo_builder][:demo_shell][:path]
property :demo_shell_fixtures_path,         String, default: node[:magento_demo_builder][:demo_shell][:fixtures_path]
property :demo_shell_module_file_list,      Array,  default: node[:magento_demo_builder][:demo_shell][:files]
property :demo_shell_media_map,             Hash,   default: node[:magento_demo_builder][:demo_shell][:media_map]
property :custom_module_list,               Hash,   default: node[:magento_demo_builder][:custom_module_list]

action :build_demo_shell_module do
    new_resource.demo_shell_module_file_list.each do |file_data|
        template "Creating #{file_data[:source]}" do
            source "#{file_data[:source]}.erb"
            path "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{file_data[:path]}/#{file_data[:source]}"
            owner new_resource.user
            group new_resource.group
            mode file_data[:mode]
            variables ({ media_map: new_resource.demo_shell_media_map })
        end
    end
end

action :remove_data_patches do
    source = "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{new_resource.demo_shell_fixtures_path}"

    ruby_block "Remove existing data patch" do
        block do
            DatabaseHelper.remove_data_patch(
                new_resource.patch_class, 
                new_resource.db_user, 
                new_resource.db_password, 
                new_resource.db_name
            )
        end
        only_if {
            Dir.exist?(source) ||
            DatabaseHelper.patch_exists(new_resource.patch_class, new_resource.db_user, new_resource.db_password, new_resource.db_name)
        }
    end
end

action :install_local_content do  
    ["data", "media"].each do |media_type|
        if Dir.exist?("#{new_resource.chef_files_path}/#{media_type}")
            media_type == "data" ? dest_path = "#{new_resource.demo_shell_fixtures_path}" : dest_path = media_type
            remote_directory "Adding #{media_type} files to module" do
                source media_type
                path "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{dest_path}"
                owner new_resource.user
                group new_resource.group
                files_owner new_resource.user
                files_group new_resource.group
                action :create_if_missing
                recursive false
                overwrite true
            end
            if media_type == "media"
                remote_directory "Adding demo shell media" do
                    source media_type
                    path "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{media_type}"
                    owner new_resource.user
                    group new_resource.group
                    files_owner new_resource.user
                    files_group new_resource.group
                    action :create_if_missing
                    recursive false
                    overwrite true
                end
                demo_shell_full_path = "#{new_resource.web_root}/#{new_resource.demo_shell_path}"
                template_manager_src = "template_manager"
                template_manager_dest = ".template-manager"
                ruby_block "Copying files from #{template_manager_src} to #{template_manager_dest}" do
                    block do
                        Dir["#{demo_shell_full_path}/#{media_type}/#{template_manager_src}/*"].each do |file|
                            FileUtils.cp(file, file.sub(template_manager_src, template_manager_dest))
                        end
                        FileUtils.rm_rf("#{demo_shell_full_path}/#{media_type}/#{template_manager_src}")
                    end
                    only_if { 
                        Dir.exist?("#{demo_shell_full_path}/#{media_type}/#{template_manager_src}") && 
                        !Dir.empty?("#{demo_shell_full_path}/#{media_type}/#{template_manager_src}") &&
                        Dir.exist?("#{demo_shell_full_path}/#{media_type}/#{template_manager_dest}") 
                    }
                end
            end
        end
    end
end

action :map_data_pack_media_to_codebase do
    unless new_resource.custom_module_list.empty?
        new_resource.custom_module_list.each do |module_key, module_value|
            if module_key.include?("data-pack")
                new_resource.demo_shell_media_map.each do |media_key, entry_path|
                    remote_directory "Adding demo shell media to codebase" do
                        source "#{entry_path[:module].include?(".template-manager") ? entry_path[:module].sub(".","").sub("-","_") : entry_path[:module]}"
                        path "#{new_resource.web_root}/#{entry_path[:codebase]}"
                        owner new_resource.user
                        group new_resource.group
                        files_owner new_resource.user
                        files_group new_resource.group
                        action :create_if_missing
                        recursive true
                        overwrite true
                    end
                end
            end
        end
    end
end

action :handle_user_custom_module_data_mapping do
    unless new_resource.custom_module_list.empty?
        new_resource.custom_module_list.each do |module_key, module_value|
            if ((module_value.is_a? Hash) && module_value.has_key?("map"))
                ruby_block "Copy files from module data pack to the codebase" do
                    block do
                        module_value[:map].each do |key, drop_paths|
                            Dir["#{new_resource.web_root}/vendor/#{module_value["name"]}/#{drop_paths[:module]}/*"].each do |file|
                                FileUtils.cp(file, "#{new_resource.web_root}/#{drop_paths[:codebase]}")
                            end
                        end
                    end
                    only_if { 
                        Dir.exist?("#{new_resource.web_root}/vendor/#{module_value["name"]}/#{drop_paths[:module]}") && 
                        !Dir.empty?("#{new_resource.web_root}/vendor/#{module_value["name"]}/#{drop_paths[:module]}") &&
                        Dir.exist?("#{new_resource.web_root}/#{drop_paths[:codebase]}") 
                    }
                end
            end
        end
    end
end

action :add_patches do
    if Dir.exist?("#{new_resource.chef_files_path}/patches")
        remote_directory "Adding patches" do
            source "patches"
            path "#{new_resource.patches_holding_area}"
            owner new_resource.user
            group new_resource.group
            files_owner new_resource.user
            files_group new_resource.group
            action :create_if_missing
            recursive false
            overwrite true
            only_if { Dir.exist?(new_resource.patches_holding_area) }
        end
    end
end