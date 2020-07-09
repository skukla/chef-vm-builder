#
# Cookbook:: apache
# Resource:: apache 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :apache
provides :apache

property :name,                     String,            name_property: true
property :user,                     String,            default: node[:apache][:init][:user]
property :group,                    String,            default: node[:apache][:init][:user]
property :package_list,             Array,             default: node[:apache][:package_list]
property :mod_list,                 Array,             default: node[:apache][:mod_list]            
property :web_root,                 String,            default: node[:apache][:init][:web_root]
property :http_port,                [String, Integer], default: node[:apache][:http_port]
property :php_version,              String,            default: node[:apache][:php][:version]
property :fpm_backend,              String,            default: node[:apache][:php][:fpm_backend]
property :fpm_port,                 [String, Integer], default: node[:apache][:php][:fpm_port]
property :ssl_port,                 [String, Integer], default: node[:apache][:ssl][:port]
property :ssl_cert_domain,          String,            default: node[:fqdn]
property :ssl_passphrase_dialog,    String,            default: node[:apache][:ssl_passphrase_dialog]
property :ssl_key_directory,        String,            default: node[:apache][:ssl][:key_directory]
property :ssl_key_file,             String,            default: "#{node[:fqdn]}.key"
property :ssl_cert_directory,       String,            default: node[:apache][:ssl][:cert_directory]
property :ssl_cert_file,            String,            default: "#{node[:fqdn]}.crt"
property :ssl_chainfile,            String,            default: node[:apache][:ssl][:chainfile]
property :demo_structure,           Hash,              default: node[:apache][:init][:demo_structure]


action :uninstall do
    execute "Remove and purge Apache" do
        command "rm -rf /etc/apache2 && rm -rf /var/www/html && apt-get --purge autoremove apache2 -y"
    end
end


action :install do
    new_resource.package_list.each do |package|
        apt_package package do
            action :install
        end
    end

    remote_file "libapache2-mod-fastcgi package source file" do
        source "http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb"
        path "/home/#{new_resource.user}/libapache2-mod-fastcgi.deb"
        owner new_resource.user
        group new_resource.group
        mode "755"
    end

    dpkg_package "libapache2-mod-fastcgi package" do
        package_name "libapache2-mod-fastcgi"
        source "/home/#{new_resource.user}/libapache2-mod-fastcgi.deb"
        only_if { ::File.exist?("/home/#{new_resource.user}/libapache2-mod-fastcgi.deb") }
    end

    execute "Enable Apache mods" do
        command "a2enmod #{new_resource.mod_list.join(" ")}"
    end

    # Create necessary logs directory
    directory "Apache logs directory" do
        path "/etc/apache2/logs"
        owner new_resource.user
        group new_resource.group
        mode "755"
    end

    # Unmask apache2 service
    execute "Unmask apache2 service" do
        command "systemctl unmask apache2"
    end
end

action :configure_apache do
    template "Apache configuration" do
        source "apache2.conf.erb"
        path "/etc/apache2/apache2.conf"
        mode "0755"
        owner "root"
        group "root"
        variables({ 
            web_root: new_resource.web_root,
            user: new_resource.user,
            group: new_resource.group,
        })
    end

    # Disable the default site
    execute "Disabling default site" do
        command "a2dissite 000-default.conf"
        only_if { ::File.exist?("/etc/apache2/sites-available/000-default.conf") }
    end
end

action :configure_ports do
    template "Ports configuration" do
        source "ports.conf.erb"
        path "/etc/apache2/ports.conf"
        mode "755"
        owner "root"
        group "root"
        variables({
            http_port: new_resource.http_port,
            ssl_port: new_resource.ssl_port
        })
    end
end

action :configure_ssl do
    template "SSL configuration" do
        source "ssl.conf.erb"
        path "/etc/apache2/conf-available/ssl.conf"
        mode "755"
        owner "root"
        group "root"
        variables({
            ssl_cert_domain: new_resource.ssl_cert_domain,
            ssl_port: new_resource.ssl_port,
            ssl_passphrase_dialog: new_resource.ssl_passphrase_dialog,
            ssl_key_directory: new_resource.ssl_key_directory,
            ssl_key_file: new_resource.ssl_key_file,
            ssl_cert_directory: new_resource.ssl_cert_directory,
            ssl_cert_file: new_resource.ssl_cert_file,
        })
    end

    execute "Enable SSL configuration" do
        command "a2enconf ssl"
    end
end

action :configure_php_fpm do
    template "PHP-FPM configuration" do
        source "php-fpm.conf.erb"
        path "/etc/apache2/conf-available/php#{new_resource.php_version}-fpm.conf"
        mode "755"
        owner "root"
        group "root"
        variables({
            fpm_backend: new_resource.fpm_backend,
            fpm_port: new_resource.fpm_port
        })
    end

    execute "Enable PHP-FPM configuration" do
        command "a2enconf php#{new_resource.php_version}-fpm"
    end

    execute "Update PHP-FPM log permissions" do
        command "chown #{new_resource.user}:#{new_resource.group} /var/log/php#{new_resource.php_version}-fpm.log"
    end
end

action :create_web_root do
    directory "Web root directory" do
        path new_resource.web_root
        owner new_resource.user
        group new_resource.group
        mode "0770"
        recursive true
        not_if { ::Dir.exist?(new_resource.web_root) }
    end
    
    execute "Set setgid on webroot" do
        command "chmod g+s #{new_resource.web_root}"
        only_if { ::Dir.exist?(new_resource.web_root) }
    end
end

action :clear_sites do
    Dir["/etc/apache2/sites-available/*"].each do |available_site|
        execute "Remove #{available_site}" do
            command "rm -rf #{available_site}"
        end
    end

    Dir["/etc/apache2/sites-enabled/*"].each do |enabled_site|
        execute "Remove #{enabled_site}" do
            command "rm -rf #{enabled_site}"
        end
    end
end

action :configure_multisite do
    # Collect vhost data
    vhost_data = Array.new
    new_resource.demo_structure.each do |scope, scope_hash|
        scope_hash.each do |code, url|
            demo_data = Hash.new
            if scope == "store_view"
                demo_data[:scope] = scope.gsub("store_view", "store")
            else
                demo_data[:scope] = scope
            end
            demo_data[:code] = code
            demo_data[:url] = url
            vhost_data << demo_data
        end
    end
    
    # Create vhosts and enable them
    vhost_data.each do |vhost|
        template "#{vhost[:url]}" do
            source "vhost.erb"
            path "/etc/apache2/sites-available/#{vhost[:url]}.conf"
            mode "755"
            owner "root"
            group "root"
            variables({
                http_port: new_resource.http_port,
                fpm_port: new_resource.fpm_port,
                server_name: vhost[:url],
                web_root: new_resource.web_root,
                ssl_port: new_resource.ssl_port,
                ssl_key_directory: new_resource.ssl_key_directory,
                ssl_key_file: new_resource.ssl_key_file,
                ssl_cert_directory: new_resource.ssl_cert_directory,
                ssl_cert_file: new_resource.ssl_cert_file,
                vhost_scope: vhost[:scope],
                vhost_scope_code: vhost[:code]
            })
        end

        execute "Enable site: #{vhost[:url]}" do
            command "a2ensite #{vhost[:url]}"
            only_if { ::File.exist?("/etc/apache2/sites-available/#{vhost[:url]}.conf") }
        end
    end
end

action :set_permissions do
    template "Envvars configuration" do
        source "envvars.erb"
        path "/etc/apache2/envvars"
        mode "755"
        owner "root"
        group "root"
        variables({
            user: new_resource.user,
            group: new_resource.group
        })
    end

    ["/etc/apache2", "/var/lib/apache2/fastcgi", "/var/lock/apache2", "/var/log/apache2"].each do |directory|
        execute "Change Apache directory permissions" do
            command "chown -R #{new_resource.user}:#{new_resource.group} #{directory}"
        end
    end
end

action :enable do
    service "apache2" do
        action :enable
    end
end

action :restart do
    service "apache2" do
        action :restart
    end
end

action :stop do
    service "apache2" do
        action :stop
    end
end