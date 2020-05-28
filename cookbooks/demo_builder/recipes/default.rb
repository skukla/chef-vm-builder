#
# Cookbook:: demo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:demo_builder][:web_root]
data_files_directory = node[:demo_builder][:data_files][:directory]
demo_shell_directory = node[:demo_builder][:demo_shell][:directory]
demo_shell_fixtures_directory = node[:demo_builder][:demo_shell][:fixtures_directory]
build_action = node[:magento][:installation][:build][:action]
data_files = Dir["#{data_files_directory}/*.csv"].map{|filename| filename.sub("#{data_files_directory}/", "") }

demo_builder "Install custom demo data" do
    action :run
    data_files data_files
    demo_shell_data_path "#{web_root}/#{demo_shell_directory}/#{demo_shell_fixtures_directory}"
    not_if {
        data_files.empty? ||
        !Dir.exist?("#{web_root}/#{demo_shell_directory}/#{demo_shell_fixtures_directory}")
    }
end