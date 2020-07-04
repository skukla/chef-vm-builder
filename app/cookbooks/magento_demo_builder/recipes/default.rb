#
# Cookbook:: magento_demo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_demo_builder][:init][:web_root]
db_user = node[:magento_demo_builder][:mysql][:db_user]
db_password = node[:magento_demo_builder][:mysql][:db_password]
db_name = node[:magento_demo_builder][:mysql][:db_name]
wysiwyg_directory = node[:magento_demo_builder][:samba][:shares][:content_media_drop]
product_media_import_directory = node[:magento_demo_builder][:samba][:shares][:product_media_drop]
sample_data_flag = node[:magento_demo_builder][:magento][:build][:sample_data]
build_action = node[:magento_demo_builder][:magento][:build][:action]
data_files_directory = node[:magento_demo_builder][:data_files][:directory]
data_files = Dir["#{data_files_directory}/*.csv"].map{|filename| filename.sub("#{data_files_directory}/", "") }
demo_shell_directory = node[:magento_demo_builder][:demo_shell][:directory]
demo_shell_fixtures_directory = node[:magento_demo_builder][:demo_shell][:fixtures_directory]
patch_class = node[:magento_demo_builder][:demo_shell][:patch_class]
chef_content_media_path = node[:magento_demo_builder][:media_files][:content_directory]
chef_product_media_path = node[:magento_demo_builder][:media_files][:products_directory]

magento_config "Create the product and content media drop directories" do
    action :create_media_drops
    not_if {
        (::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install") ||
        Dir.exist?("#{wysiwyg_directory}") ||
        Dir.exist?("#{product_media_import_directory}") ||
        sample_data_flag
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

magento_demo_builder "Install custom demo data files" do
    action :run
    data_files data_files
    demo_shell_data_path "#{web_root}/#{demo_shell_directory}/#{demo_shell_fixtures_directory}"
    not_if {
        data_files.empty? ||
        !Dir.exist?("#{web_root}/#{demo_shell_directory}/#{demo_shell_fixtures_directory}")
    }
end

magento_demo_builder "Remove existing custom demo media" do
    action :remove_media
    content_media_destination wysiwyg_directory
    product_media_destination product_media_import_directory
    not_if {
        wysiwyg_directory.empty? ||
        product_media_import_directory.empty? &&
        sample_data_flag
    }
    only_if {
        Dir.exist?("#{wysiwyg_directory}") &&
        Dir.exist?("#{product_media_import_directory}")
    }
end

magento_demo_builder "Copy custom demo media" do
    action :add_media
    content_media_source chef_content_media_path
    product_media_source chef_product_media_path
    content_media_destination wysiwyg_directory
    product_media_destination product_media_import_directory
    not_if {
        wysiwyg_directory.empty? ||
        product_media_import_directory.empty? &&
        sample_data_flag
    }
    only_if {
        Dir.exist?("#{wysiwyg_directory}") &&
        Dir.exist?("#{product_media_import_directory}")
    }
end

magento_app "Set permissions on media directories and files" do
    action :set_permissions
    permission_dirs ["var/", "pub/"]
end