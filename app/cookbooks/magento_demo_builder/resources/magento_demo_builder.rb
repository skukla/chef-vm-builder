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

action :remove_data do
    source = "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{new_resource.demo_shell_fixtures_path}"

    execute "Remove existing data files" do
        command "rm -rf #{source}/*"
        only_if { Dir.exist?(source) }
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

action :remove_demo_shell_media do
    new_resource.demo_shell_media_map.each do |key, drop_paths|
        source = "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{drop_paths[:module]}"
        
        execute "Remove existing #{key} media from demo shell: #{new_resource.demo_shell_path}/#{drop_paths[:module]}" do
            command "rm -rf #{source}/*"
            not_if { Dir.empty?(source) }
            only_if { Dir.exist?(source) }
        end
    end
end

action :install_data do  
    source = "#{new_resource.chef_files_path}/data"
    destination = "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{new_resource.demo_shell_fixtures_path}"

    execute "Copy data files into demo shell module" do
        command "cp -R #{source}/* #{destination}"
        not_if { Dir.empty?(source) }
        only_if { Dir.exist?(source) && Dir.exist?(destination) }
    end

    execute "Update data file permissions" do
        command "chown -R #{new_resource.user}:#{new_resource.group} #{destination}/*"
        not_if { Dir.empty?(destination)
        }
    end
end

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

action :create_codebase_media_drops do
    new_resource.demo_shell_media_map.each do |drop_name, drop_paths|
        directory "#{drop_name} Codebase Media Drop" do
            path "#{new_resource.web_root}/#{drop_paths[:codebase]}"
            owner new_resource.user
            group new_resource.group
            mode "777"
            recursive true
        end
    end
end

action :add_media_to_demo_shell do
    new_resource.demo_shell_media_map.each do |key, drop_paths|
        key.to_s == "template_manager" ? module_path = drop_paths[:module].sub(".", "").sub("-","_") : module_path = drop_paths[:module]
        source = "#{new_resource.chef_files_path}/#{module_path.to_s}"
        destination = "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{drop_paths[:module]}"

        execute "Copy #{key} media into module location: #{destination}" do
            command "cp -R #{source}/* #{destination}"
            not_if { Dir.empty?(source) }
            only_if { Dir.exist?(source) && Dir.exist?(destination) }
        end
            
        execute "Update demo shell media permissions" do
            command "chown -R #{new_resource.user}:#{new_resource.group} #{destination}/*"
            not_if { Dir.empty?(destination) }
        end
    end
end

# action :map_demo_shell_media_to_codebase do
#     new_resource.demo_shell_media_map.each do |key, drop_paths|
#         key.to_s == "template_manager" ? module_path = drop_paths[:module].sub(".", "").sub("-","_") : module_path = drop_paths[:module]
#         source = "#{new_resource.chef_files_path}/#{module_path.to_s}"
#         destination = "#{new_resource.web_root}/#{new_resource.demo_shell_path}/#{drop_paths[:module]}"

#         execute "Copy #{key} media into demo shell location: #{destination}" do
#             command "cp -R #{source}/* #{destination}"
#             not_if { Dir.empty?(source) || Dir.empty?(destination) || key == "catalog" }
#             only_if { Dir.exist?(source) && Dir.exist?(destination) }
#         end
        
#         execute "Update demo shell media permissions" do
#             command "chown -R #{new_resource.user}:#{new_resource.group} #{destination}/*"
#             not_if { Dir.empty?(source) || Dir.empty?(destination) || key == "catalog" }
#         end
#     end
# end

action :map_data_pack_media_to_codebase do
    new_resource.custom_module_list.each do |module_key, module_value|
        if module_key.include?("data-pack")
            new_resource.demo_shell_media_map.each do |key, drop_paths|
                key.to_s == "template_manager" ? module_path = drop_paths[:module].sub(".", "").sub("-","_") : module_path = drop_paths[:module]
                source = "#{new_resource.web_root}/vendor/#{module_value["name"]}/#{drop_paths[:module]}"
                destination = "#{new_resource.web_root}/#{drop_paths[:codebase]}"

                execute "Copy #{module_value["name"].split("/")[1]} #{key} media into codebase location: #{destination}" do
                    command "cp -R #{source}/* #{destination}"
                    not_if { Dir.empty?(source) }
                    only_if { Dir.exist?(source) && Dir.exist?(destination) }
                end
            end
        end
    end
end

action :handle_user_custom_module_data_mapping do
    new_resource.custom_module_list.each do |module_key, module_value|
        if (module_value.is_a? Hash) && module_value.has_key?("map")
            module_value[:map].each do |key, drop_paths|
                source = "#{new_resource.web_root}/vendor/#{module_value["name"]}/#{drop_paths[:module]}"
                destination = "#{new_resource.web_root}/#{drop_paths[:codebase]}"
                
                execute "Copy #{module_value["name"].split("/")[1]} #{key} media into codebase location: #{destination}" do
                    command "cp -R #{source}/* #{destination}"
                    not_if { Dir.empty?(source) || Dir.empty?(destination) }
                    only_if { Dir.exist?(source) && Dir.exist?(destination) }
                end
            end
        end
    end
end

action :add_patches do
    if Dir.exist?("#{new_resource.chef_files_path}/patches")
        source = Dir.entries("#{new_resource.chef_files_path}/patches")
        destination = new_resource.patches_holding_area

        patch_file_entries = (source - [".DS_Store", ".gitignore", ".", ".."])
        patch_file_entries.each do |patch|
            execute "Copy #{patch} into patches holding area" do
                command "cp #{source}/patches/#{patch} #{destination}"
                not_if { Dir.empty?(source) }
                only_if { Dir.exist?(source) && Dir.exist?(destination) }
            end
        end
    end
end