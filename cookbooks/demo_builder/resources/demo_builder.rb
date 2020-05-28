#
# Cookbook:: demo_builder
# Resource:: demo_builder
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :demo_builder
property :name,                   String, name_property: true
property :user,                   String, default: node[:demo_builder][:user]
property :group,                  String, default: node[:demo_builder][:user]
property :web_root,               String, default: node[:demo_builder][:web_root]
property :demo_shell_data_path,   String
property :data_files,             Array

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
