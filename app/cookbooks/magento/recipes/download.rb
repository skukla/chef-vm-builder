#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
web_root = node[:magento][:init][:web_root]
version = node[:magento][:installation][:options][:version]
family = node[:magento][:installation][:options][:family]
build_action = node[:magento][:installation][:build][:action]
sample_data = node[:magento][:installation][:build][:sample_data]
custom_module_list = node[:magento][:custom_module_list]
apply_patches = node[:magento][:patches][:apply]
use_elasticsearch = node[:magento][:elasticsearch][:use]

php "Switch PHP user to #{user}" do
    action :set_user
    php_user user
end

magento_app "Clear the cron schedule" do
    action :clear_cron_schedule
    only_if { 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && 
        ::File.exist?("/var/spool/cron/crontabs/#{user}") && 
        build_action != "install"  
    }
end

magento_app "Disable cron" do
    action :disable_cron
    only_if {
        ::File.exist?("/var/spool/cron/crontabs/#{user}") && 
        build_action != "install" 
    }
end

magento_app "Set auth.json credentials" do
    action :set_auth_credentials
end

composer "Create Magento #{family.capitalize} #{version} project" do
    action :create_project
    repository_url "https://repo.magento.com/"
    options ["no-install"]
    package_version "#{version}"
    project_name "magento/project-#{family}-edition"
    project_directory "#{web_root}"
    only_if { 
        ::Dir.empty?("#{web_root}") && 
        (build_action == "install" || build_action == "force_install") 
    }
end

composer "Set the project stability setting" do
    action :set_project_stability
    only_if { 
        ::File.exist?("#{web_root}/composer.json")
    }
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && 
        (build_action == "install" || build_action != "reinstall") 
    }
end

composer "Update the project sort-packages setting" do
    action :update_sort_packages
    only_if { 
        ::File.exist?("#{web_root}/composer.json")
    }
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && 
        (build_action == "install" || build_action != "reinstall")
    }
end

magento_app "Update the Magento version" do
    action :update_version
    only_if { 
        ::File.exist?("#{web_root}/composer.json") && 
        !::File.foreach("#{web_root}/composer.json").grep(/#{version}/).any? && 
        build_action == "update"  
    }
end

magento_app "Remove outdated modules" do
    action :remove_modules
    not_if { 
        ::File.foreach("#{web_root}/composer.json").grep(/replace/).any? || 
        (::File.exist?("#{web_root}/var/.first-run-state.flag") && (build_action == "install" || build_action == "reinstall")) 
    }
end

composer "Require the B2B modules" do
    action :require
    package_name "magento/extension-b2b"
    package_version "^1.0"
    options ["no-update"]
    not_if {
        ::File.foreach("#{web_root}/composer.json").grep(/extension-b2b/).any? ||
        (::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install")
    }
    only_if { 
        family == "enterprise" && 
        ::File.exist?("#{web_root}/composer.json")
    }
end

if apply_patches && ((build_action == "force_install") || (apply_patches && build_action == "install" && !::File.exist?("#{web_root}/var/.first-run-state.flag")))
    include_recipe "magento_patches::default"
end

unless custom_module_list.empty?
    custom_module_list.each do |custom_module_key, custom_module_data|
        custom_module "Add #{custom_module_data[:module_name]}" do
            action :download
            package_name "#{custom_module_data[:package_name]}"
            module_name "#{custom_module_data[:module_name]}"
            package_version "#{custom_module_data[:package_version]}"
            repository_url "#{custom_module_data[:repository_url]}"
            options ["no-update"]
            not_if { 
                build_action == "reinstall" || 
                (::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install") || 
                (!use_elasticsearch && custom_module_data[:module_name].include?("elasticsuite")) 
            }
        end
    end
end

magento_app "Download the codebase" do
    action :download
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "force_install" }
    only_if { 
        !::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install" || 
        build_action == "force_install"
    }
end

magento_app "Update the codebase" do
    action :update
    only_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "update" }
end

magento_app "Add sample data" do
    action :add_sample_data
    not_if { 
        ::File.exist?("#{web_root}/var/.sample-data-state.flag") || 
        !sample_data 
    }
end

magento_app "Set permissions after downloading code" do
    action :set_permissions
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install" }
end