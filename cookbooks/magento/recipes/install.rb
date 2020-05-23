#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:web_root]
build_action = node[:magento][:installation][:build][:action]
force_install = node[:magento][:installation][:build][:force_install]
install_settings = {
    backend_frontname: node[:magento][:installation][:settings][:backend_frontname],
    unsecure_base_url: node[:magento][:installation][:settings][:secure_base_url],
    language: node[:magento][:installation][:settings][:language],
    timezone: node[:magento][:installation][:settings][:timezone],
    currency: node[:magento][:installation][:settings][:currency],
    admin_firstname: node[:magento][:installation][:settings][:admin_firstname],
    admin_lastname: node[:magento][:installation][:settings][:admin_lastname],
    admin_email: node[:magento][:installation][:settings][:admin_email],
    admin_user: node[:magento][:installation][:settings][:admin_user],
    admin_password: node[:magento][:installation][:settings][:admin_password],
    use_rewrites: node[:magento][:installation][:settings][:use_rewrites],
    use_secure_frontend: node[:magento][:installation][:settings][:use_secure_frontend],
    use_secure_admin: node[:magento][:installation][:settings][:use_secure_admin],
    cleanup_database: node[:magento][:installation][:settings][:cleanup_database],
    session_save: node[:magento][:installation][:settings][:session_save],
    encryption_key: node[:magento][:installation][:settings][:encryption_key]
}

include_recipe "mysql::configure_pre_install" if (!File.exist?("#{web_root}/app/etc/config.php") && build_action == "install") || build_action == "upgrade" || force_install

magento_app "Install Magento" do
    action :install
    install_settings install_settings
    only_if { (!File.exist?("#{web_root}/app/etc/config.php") && build_action == "install") || force_install }
end

magento_cli "Upgrade Magento database" do
    action :db_upgrade
    only_if { File.exist?("#{web_root}/app/etc/config.php") && build_action == "upgrade" }
end

magento_cli "Re-compile dependency injections" do
    action :di_compile
    only_if { File.exist?("#{web_root}/app/etc/config.php") && build_action == "upgrade" }
end

magento_cli "Deploy static content" do
    action :deploy_static_content
    only_if { File.exist?("#{web_root}/app/etc/config.php") && build_action == "upgrade" }
end

include_recipe "mysql::configure_post_install" if (File.exist?("#{web_root}/app/etc/config.php") && (build_action == "install" || build_action == "upgrade")) || force_install

magento_app "Set permissions after installation or database upgrade" do
    action :set_permissions
    only_if { (File.exist?("#{web_root}/app/etc/config.php") && (build_action == "install" || build_action == "upgrade")) || force_install }
end

