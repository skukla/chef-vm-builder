#
# Cookbook:: magento_demo_builder
# Resource:: magento_demo_builder
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_demo_builder
property :name,                   String, name_property: true
property :user,                   String, default: node[:magento_demo_builder][:user]
property :group,                  String, default: node[:magento_demo_builder][:user]
property :web_root,               String, default: node[:magento_demo_builder][:web_root]
property :demo_shell_data_path,   String
property :data_files,             Array
property :patch_class,            String
property :db_user,                String, default: node[:magento_demo_builder][:database][:user]
property :db_password,            String, default: node[:magento_demo_builder][:database][:password]
property :db_name,                String, default: node[:magento_demo_builder][:database][:name]

action :run do
    new_resource.data_files.each do |file|
        cookbook_file "#{new_resource.demo_shell_data_path}/#{file}" do
            source "#{file}"
            owner "#{new_resource.user}"
            group "#{new_resource.group}"
            mode "755"
        end
    end
end

action :refresh_data do
    ruby_block "Remove existing data patch" do
        block do
            DatabaseHelper.remove_data_patch(
                "#{new_resource.patch_class}", 
                "#{new_resource.db_user}", 
                "#{new_resource.db_password}", 
                "#{new_resource.db_name}"
            )
        end
    end
end

