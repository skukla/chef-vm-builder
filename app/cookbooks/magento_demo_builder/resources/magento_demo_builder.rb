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
property :patches_holding_area,             String, default: node[:magento_demo_builder][:magento_patches][:holding_area]
property :demo_shell_vendor,                String, default: node[:magento_demo_builder][:demo_shell][:vendor]
property :demo_shell_module_file_list,      Array,  default: node[:magento_demo_builder][:demo_shell][:files]
property :custom_module_list,               Hash,   default: node[:magento_demo_builder][:custom_module_list]
property :custom_module_data,               Hash

action :remove_data_patches do
    Dir["#{new_resource.chef_files_path}/demo/*"].each do |entry|
        entry_path = [::File.dirname(entry), ::File.basename(entry)].join("/").split("/").pop(1).join
        if new_resource.custom_module_data[:value]["repository_url"] == entry_path
            module_name_data = StringReplaceHelper.prepare_module_names(new_resource.custom_module_data[:value]["name"], new_resource.demo_shell_vendor)
            package_name = module_name_data[:package_name]
            vendor = module_name_data[:vendor]
            module_name = module_name_data[:module_name]
            patch_class = "#{vendor}\\#{module_name}\\Setup\\Patch\\Data"
            source = "#{new_resource.web_root}/app/code/#{vendor}/#{module_name}/fixtures"
            
            ruby_block "Remove existing data patch for #{new_resource.custom_module_data[:value]["name"]}" do
                block do
                    DatabaseHelper.remove_data_patch(
                        patch_class, 
                        new_resource.db_user, 
                        new_resource.db_password, 
                        new_resource.db_name
                    )
                end
                only_if {
                    Dir.exist?(source) ||
                    DatabaseHelper.patch_exists(
                        patch_class, 
                        new_resource.db_user, 
                        new_resource.db_password, 
                        new_resource.db_name
                    )
                }
            end
        end
    end
end

action :build_local_data_pack_modules do
    unless new_resource.custom_module_data[:value]["repository_url"].nil? 
        Dir["#{new_resource.chef_files_path}/demo/*"].each do |entry|
            entry_path = [::File.dirname(entry), ::File.basename(entry)].join("/").split("/").pop(1).join
            if new_resource.custom_module_data[:value]["repository_url"] == entry_path
                module_name_data = StringReplaceHelper.prepare_module_names(new_resource.custom_module_data[:value]["name"], new_resource.demo_shell_vendor)
                package_name = module_name_data[:package_name]
                vendor = module_name_data[:vendor]
                module_name = module_name_data[:module_name]
                [
                    "app", 
                    "app/code",
                    "app/code/#{vendor}", 
                    "app/code/#{vendor}/#{module_name}",
                    "app/code/#{vendor}/#{module_name}/media",
                    "app/code/#{vendor}/#{module_name}/fixtures",
                    "app/code/#{vendor}/#{module_name}/etc",
                    "app/code/#{vendor}/#{module_name}/Setup",
                    "app/code/#{vendor}/#{module_name}/Setup/Patch",
                    "app/code/#{vendor}/#{module_name}/Setup/Patch/Data"
                ].each do |dir|
                    directory "Creating #{dir}" do
                        path "#{new_resource.web_root}/#{dir}"
                        owner new_resource.user
                        group new_resource.group
                        only_if { Dir.exist?("#{new_resource.chef_files_path}/demo/#{new_resource.custom_module_data[:value]["repository_url"]}") }
                    end
                end
                new_resource.demo_shell_module_file_list.each do |file_data|
                    template "Creating #{file_data[:source]}" do
                        source "#{file_data[:source]}.erb"
                        path "#{new_resource.web_root}/app/code/#{vendor}/#{module_name}/#{file_data[:path]}/#{file_data[:source]}"
                        owner new_resource.user
                        group new_resource.group
                        mode file_data[:mode]
                        variables ({
                            package_name: package_name,
                            vendor: module_name_data[:vendor],
                            module_name: module_name
                        })
                        only_if { 
                            Dir.exist?("#{new_resource.chef_files_path}/demo/#{new_resource.custom_module_data[:value]["repository_url"]}") &&
                            Dir.exist?("#{new_resource.web_root}/app/code/#{vendor}/#{module_name}")
                        }
                    end
                end
            end
        end
    end
end

action :install_local_data_pack_content do  
    Dir["#{new_resource.chef_files_path}/demo/*"].each do |entry|
        entry_path = [::File.dirname(entry), ::File.basename(entry)].join("/").split("/").pop(1).join        
        if new_resource.custom_module_data[:value]["repository_url"] == entry_path
            module_name_data = StringReplaceHelper.prepare_module_names(new_resource.custom_module_data[:value]["name"], new_resource.demo_shell_vendor)
            package_name = module_name_data[:package_name]
            vendor = module_name_data[:vendor]
            module_name = module_name_data[:module_name]
            
            ["data", "media"].each do |media_type|
                if Dir.exist?("#{new_resource.chef_files_path}/demo/#{new_resource.custom_module_data[:value]["repository_url"]}/#{media_type}")
                    media_type == "data" ? dest_path = "fixtures" : dest_path = media_type
                    remote_directory "Adding #{media_type} files to #{vendor}/#{module_name}" do
                        source "demo/#{new_resource.custom_module_data[:value]["repository_url"]}/#{media_type}"
                        path "#{new_resource.web_root}/app/code/#{vendor}/#{module_name}/#{dest_path}"
                        owner new_resource.user
                        group new_resource.group
                        files_owner new_resource.user
                        files_group new_resource.group
                        action :create_if_missing
                        recursive false
                        overwrite true
                    end
                    if media_type == "media"
                        remote_directory "#{module_name.downcase} media" do
                            source "demo/#{new_resource.custom_module_data[:value]["repository_url"]}/#{media_type}"
                            path "#{new_resource.web_root}/app/code/#{vendor}/#{module_name}/#{media_type}"
                            owner new_resource.user
                            group new_resource.group
                            files_owner new_resource.user
                            files_group new_resource.group
                            action :create_if_missing
                            recursive false
                            overwrite true
                        end
                        module_full_path = "#{new_resource.web_root}/#{vendor}/#{module_name}"
                        template_manager_src = "template_manager"
                        template_manager_dest = ".template-manager"
                        ruby_block "Copying files from #{template_manager_src} to #{template_manager_dest}" do
                            block do
                                Dir["#{module_full_path}/#{media_type}/#{template_manager_src}/*"].each do |file|
                                    FileUtils.cp(file, file.sub(template_manager_src, template_manager_dest))
                                end
                                FileUtils.rm_rf("#{module_full_path}/#{media_type}/#{template_manager_src}")
                            end
                            only_if { 
                                Dir.exist?("#{module_full_path}/#{media_type}/#{template_manager_src}") && 
                                !Dir.empty?("#{module_full_path}/#{media_type}/#{template_manager_src}") &&
                                Dir.exist?("#{module_full_path}/#{media_type}/#{template_manager_dest}") 
                            }
                        end
                    end
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