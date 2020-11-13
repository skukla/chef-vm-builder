#
# Cookbook:: magento_demo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
sample_data_flag = node[:magento_demo_builder][:magento][:build][:sample_data]
build_action = node[:magento_demo_builder][:magento][:build][:action]
web_root = node[:magento_demo_builder][:init][:web_root]
custom_module_list = node[:magento_demo_builder][:custom_module_list]

magento_config "Create samba drop directories" do
    action :create_samba_drops
end

unless custom_module_list.empty?    
    custom_module_list.each do |module_key, module_value|
        magento_demo_builder "Remove existing data for the #{module_value["name"]} module from the database" do
            action :remove_data_patches
            custom_module_data ({
                key: module_key,
                value: module_value
            })
            only_if { build_action == "update" }
        end

        magento_demo_builder "Build the #{module_value["name"]} module" do
            action :build_local_data_pack_modules
            custom_module_data ({
                key: module_key,
                value: module_value
            })
        end

        magento_demo_builder "Install data files into the #{module_value["name"]} module" do
            action :install_local_data_pack_content
            custom_module_data ({
                key: module_key,
                value: module_value
            })
        end
    end
end

magento_app "Set permissions on media directories and files" do
    action :set_permissions
    permission_dirs ["var/", "pub/"]
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install" }
end