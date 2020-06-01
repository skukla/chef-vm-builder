#
# Cookbook:: magentodemo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_demo_builder][:web_root]
data_files_directory = node[:magento_demo_builder][:data_files][:directory]
data_files = Dir["#{data_files_directory}/*.csv"].map{|filename| filename.sub("#{data_files_directory}/", "") }
demo_shell_directory = node[:magento_demo_builder][:demo_shell][:directory]
demo_shell_fixtures_directory = node[:magento_demo_builder][:demo_shell][:fixtures_directory]
patch_class = node[:magento_demo_builder][:demo_shell][:patch_class]
db_user = node[:magento_demo_builder][:database][:user]
db_password = node[:magento_demo_builder][:database][:password]
db_name = node[:magento_demo_builder][:database][:name]
build_action = node[:magento_demo_builder][:build][:action]

magento_demo_builder "Install custom demo data files" do
    action :run
    data_files data_files
    demo_shell_data_path "#{web_root}/#{demo_shell_directory}/#{demo_shell_fixtures_directory}"
    not_if {
        data_files.empty? ||
        !Dir.exist?("#{web_root}/#{demo_shell_directory}/#{demo_shell_fixtures_directory}")
    }
end

magento_demo_builder "Remove existing data from the database" do
    action :refresh_data
    patch_class "#{patch_class}"
    not_if {
        data_files.empty? ||
        !Dir.exist?("#{web_root}/#{demo_shell_directory}/#{demo_shell_fixtures_directory}") ||
        (::File.exist?("#{web_root}/app/etc/config.php") && (build_action == "install")) ||
        !DatabaseHelper.patch_exists(
            "#{patch_class}", 
            "#{db_user}", 
            "#{db_password}", 
            "#{db_name}"
        )
    }
    only_if {
        build_action == "update"
    }
end