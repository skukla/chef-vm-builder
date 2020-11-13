#
# Cookbook:: magento
# Recipe:: run_build_hooks
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]
warm_cache = node[:magento][:build][:hooks][:warm_cache]
enable_media_gallery = node[:magento][:build][:hooks][:enable_media_gallery]
commands = node[:magento][:build][:hooks][:commands]
media_gallery_commands = ["config:set system/media_gallery/enabled 1", "media-gallery:sync"]
vm_cli_commands = commands.select{ |command| !command.include?(":") }
magento_cli_commands = commands.select{ |command| command.include?(":") }

magento_cli "Running the enable_media_gallery hook" do
    action :run
    command_list media_gallery_commands
    only_if { enable_media_gallery }
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "reinstall" }
end

magento_cli "Running user Magento CLI hooks" do
    action :run
    command_list magento_cli_commands
    not_if { 
        commands.empty? || 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "reinstall"
    }
end

vm_cli "Running user VM CLI hooks" do
    action :run
    command_list vm_cli_commands
    not_if { 
        commands.empty? ||
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "reinstall"
    }
end

vm_cli "Running the warm cache hook" do
    action :run
    command_list "warm-cache"
    only_if { warm_cache }
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "reinstall" }
end