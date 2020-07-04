#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:installation][:build][:action]
apply_deploy_mode = node[:magento][:installation][:build][:deploy_mode][:apply]
install_settings = {
    backend_frontname: node[:magento][:installation][:settings][:backend_frontname],
    unsecure_base_url: node[:magento][:installation][:settings][:unsecure_base_url],
    secure_base_url: node[:magento][:installation][:settings][:secure_base_url],
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

mysql "Configure MySQL settings before installation" do
    action [:configure_pre_app_install, :restart]
    not_if {
        ::File.exist?("#{web_root}/app/etc/config.php") && build_action == "install"
    }
end

mysql "Create the database" do
    action :create_database
end

magento_app "Install Magento" do
    action :install
    install_settings install_settings
    not_if { 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "reinstall"
    }
end

magento_app "Upgrade Magento database" do
    action :db_upgrade
    only_if { 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "update" 
    }
end

magento_app "Re-compile dependency injections" do
    action :di_compile
    not_if {
        apply_deploy_mode
    }
    only_if { 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "update"
    }
end

magento_app "Deploy static content" do
    action :deploy_static_content
    not_if {
        apply_deploy_mode
    }
    only_if { 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "update"
    }
end

mysql "Configure MySQL settings after installation" do
    action [:configure_post_app_install, :restart]
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
end

magento_app "Set permissions after installation or database upgrade" do
    action :set_permissions
    not_if { 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install" 
    }
end