#
# Cookbook:: magento
# Resource:: magento_app 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_app
property :name,                 String, name_property: true
property :pwd,                  String, default: node[:magento][:web_root]
property :web_root,             String, default: node[:magento][:web_root]
property :composer_file,        String, default: node[:magento][:composer_file]
property :permission_dirs,      Array,  default: ["var/", "pub/", "app/etc/", "generated/"]
property :user,                 String, default: node[:magento][:user]
property :group,                String, default: node[:magento][:user]
property :family,               String, default: node[:magento][:installation][:options][:family]
property :version,              String, default: node[:magento][:installation][:options][:version]
property :minimum_stability,    String, default: node[:magento][:installation][:options][:minimum_stability]
property :modules_to_remove,    String
property :db_host,              String, default: node[:magento][:database][:host]
property :db_user,              String, default: node[:magento][:database][:user]
property :db_password,          String, default: node[:magento][:database][:password]
property :db_name,              String, default: node[:magento][:database][:name]
property :install_settings,     Hash

action :install do
    install_string = "--db-host=#{new_resource.db_host} --db-name=#{new_resource.db_name} --db-user=#{new_resource.db_user} --db-password=#{new_resource.db_password} --backend-frontname=#{new_resource.install_settings[:backend_frontname]} --base-url=#{new_resource.install_settings[:unsecure_base_url]} --language=#{new_resource.install_settings[:language]} --timezone=#{new_resource.install_settings[:timezone]} --currency=#{new_resource.install_settings[:currency]} --admin-firstname=#{new_resource.install_settings[:admin_firstname]} --admin-lastname=#{new_resource.install_settings[:admin_lastname]} --admin-email=#{new_resource.install_settings[:admin_email]} --admin-user=#{new_resource.install_settings[:admin_user]} --admin-password=#{new_resource.install_settings[:admin_password]}"
    rewrites_string = "--use-rewrites=#{ValueHelper.process_value(new_resource.install_settings[:use_rewrites])}"
    use_secure_frontend_string = "--use-secure=#{ValueHelper.process_value(new_resource.install_settings[:use_secure_frontend])}"
    use_secure_admin_string = "--use-secure-admin=#{ValueHelper.process_value(new_resource.install_settings[:use_secure_admin])}"
    secure_url_string = "--base-url-secure=#{new_resource.install_settings[:secure_base_url]}"
    cleanup_database_string = "--cleanup-database"
    session_save_string = "--session-save=#{new_resource.install_settings[:session_save]}"
    encryption_key_string = "--key=#{new_resource.install_settings[:encryption_key]}"

    # Create the master install string
    install_string = [install_string, rewrites_string].join(" ") if new_resource.install_settings[:use_rewrites]
    install_string = [install_string, use_secure_admin_string].join(" ") if new_resource.install_settings[:use_secure_admin]
    install_string = [install_string, use_secure_frontend_string].join(" ") if new_resource.install_settings[:use_secure_frontend]
    install_string = [install_string, secure_url_string].join(" ") if new_resource.install_settings[:use_secure_frontend] || new_resource.install_settings[:use_secure_admin]
    install_string = [install_string, cleanup_database_string, session_save_string, encryption_key_string].join(" ")
    
    ruby_block "Create the Magento database" do
        block do
            %x[mysql --user=root -e "CREATE DATABASE IF NOT EXISTS #{new_resource.db_name};"]
            %x[mysql --user=root -e "GRANT ALL ON #{new_resource.db_name}.* TO '#{new_resource.db_user}'@'#{new_resource.db_host}' IDENTIFIED BY '#{new_resource.db_password}' WITH GRANT OPTION;"]
        end
        action :create
    end
    
    magento_cli "Install via the Magento CLI" do
        action :install
        install_string install_string
    end
end

action :add_sample_data do
    directory "Create composer_home directory" do
        path "#{new_resource.web_root}/var/composer_home"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "0777"
    end

    execute "Copy auth.json into place" do
        command "cp /home/#{new_resource.user}/.#{new_resource.composer_file}/auth.json #{new_resource.web_root}/var/composer_home/"
        only_if { ::File.exist?("/home/#{new_resource.user}/.#{new_resource.composer_file}/auth.json") }
    end

    file "Set auth.json permissions" do
        path "#{new_resource.web_root}/var/composer_home/auth.json"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "0777"
        only_if { ::File.exist?("#{new_resource.web_root}/var/composer_home/auth.json") }
    end

    magento_cli "Download sample data" do
        action :deploy_sample_data
    end
end

action :upgrade_version do
    ruby_block "#{new_resource.name}" do
        block do
            StringReplaceHelper.upgrade_app_version("#{new_resource.version}", "#{new_resource.family}", "#{new_resource.web_root}/composer.json")
        end
    end
end

action :set_permissions do
    new_resource.permission_dirs.each do |directory|
        execute "Update #{directory} permissions" do
            command "sudo chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.web_root}/#{directory} && sudo chmod -R 777 #{new_resource.web_root}/#{directory}"
            only_if { Dir.exist?("#{new_resource.web_root}/#{directory}") }
        end
    end
end

action :set_minimum_stability do
    ruby_block "#{new_resource.name}" do
        block do
            StringReplaceHelper.set_minimum_stability("#{new_resource.minimum_stability}", "#{new_resource.web_root}/composer.json")
        end
    end
end

action :remove_modules do
    ruby_block "#{new_resource.name}" do
        block do
            StringReplaceHelper.remove_modules("#{new_resource.modules_to_remove}", "#{new_resource.web_root}/composer.json")
        end
    end 
end

action :clear_cron_schedule do
    ruby_block "Clear the cron schedule table" do
        block do
            %x[mysql -uroot -e "USE #{new_resource.db_name};DELETE FROM cron_schedule;"]
        end
        action :create
    end
end

action :uninstall do
    app_content = Dir.entries("#{new_resource.web_root}") - %w{ . .. }
    app_content_string = Array.new
    app_content.each do |entry|
        app_content_string << "#{new_resource.web_root}/#{entry}"
    end
    execute "Clear the web root" do
        command "sudo rm -rf #{app_content_string.join(" ")}"
    end
end
