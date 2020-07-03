#
# Cookbook:: cli
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
cli_directories = node[:cli][:directories]
cli_files = node[:cli][:files]

cli "Install VM CLI" do
    action [:create_directories, :install]
    configuration({
        cli_directories: cli_directories,
        cli_files: cli_files
    })
end