#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
version = node[:magento][:installation][:options][:version]
family = node[:magento][:installation][:options][:family]
build_action = node[:magento][:installation][:build][:action]
sample_data = node[:magento][:installation][:build][:sample_data]
custom_modules = node[:magento][:custom_modules]
modules_to_remove = node[:magento][:installation][:build][:modules_to_remove]
apply_patches = node[:magento_patches][:apply]

switch_php_user "#{user}"

composer "Create Magento #{version} project" do
    action :create_project
    repository_url "https://repo.magento.com/"
    options ["no-install"]
    package_version "#{version}"
    project_name "magento/project-#{family}-edition"
    project_directory "#{web_root}"
    only_if { Dir.empty?("#{web_root}") && build_action == "install" }
end

magento_app "Upgrade Magento" do
    action :upgrade_version
    only_if { build_action == "upgrade" && !File.foreach("#{web_root}/composer.json").grep(/#{version}/).any? }
end

# Since composer create-project --stability flag doesn't work...
magento_app "Set project stability" do
    action :set_minimum_stability
    only_if { ::File.exist?("#{web_root}/composer.json") && build_action == "install" }
end

magento_app "Remove outdated modules" do
    action :remove_modules
    modules_to_remove modules_to_remove
    only_if { ::File.exist?("#{web_root}/composer.json") && !::File.foreach("#{web_root}/composer.json").grep(/replace/).any? && build_action == "install" }
end

composer "Require B2B modules" do
    action :require
    package_name "magento/extension-b2b"
    package_version "^1.0"
    options ["no-update"]
    only_if { family == "enterprise" && !::File.foreach("#{web_root}/composer.json").grep(/extension-b2b/).any? && build_action == "install"}
end

if !custom_modules.nil? && (build_action == "install" || build_action == "custom_modules")
    include_recipe "magento_custom_modules::download"
end

if apply_patches
    include_recipe "magento_patches::download"
    include_recipe "magento_patches::apply"
end

# Magento hasn't been installed yet...
if !File.exist?("#{web_root}/app/etc/config.php")
    composer "Download codebase" do
        action :install
        only_if { build_action == "install" }
    end
# Magento is installed already
else
    magento_cli "Disable cron" do
        action :disable_cron
        only_if { "su #{user} -c 'crontab -l'" && build_action == "install" }
    end

    magento_app "Clear cron schedule" do
        action :clear_cron_schedule
        only_if { "su #{user} -c 'crontab -l'" && build_action == "install" }
    end

    composer "Update codebase" do
        action :upgrade
        only_if { build_action == "upgrade" || build_action == "custom_modules" }
    end
end

magento_app "Add sample data" do
    action :add_sample_data
    only_if { !::File.exist?("#{web_root}/var/.sample-data-state.flag") && sample_data && build_action == "install" }
end

magento_app "Set permissions" do
    action :set_permissions
    only_if { build_action == "install" || build_action == "upgrade" || build_action == "custom_modules" }
end