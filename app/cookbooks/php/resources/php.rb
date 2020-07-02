#
# Cookbook:: php
# Resource:: php 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :php
provides :php

property :name,                     String, name_property: true
property :php_user,                 String
property :vm_user,                  String, default: node[:php][:user]
property :vm_group,                 String, default: node[:php][:user]
property :version,                  String, default: node[:php][:version]
property :extension_list,           Array
property :sendmail_path,            String
property :configuration,            Hash

action :install do
    # Add PHP repository
    apt_repository "php-#{new_resource.version}" do
        uri 'ppa:ondrej/php'
        components ['main']
        distribution "bionic"
        action :add
        retries 3
        not_if { ::File.exist?("/etc/apt/sources.list.d/php-#{new_resource.version}.list") }
    end

    # Install specified PHP and extensions
    # Use string replacement to inject the PHP version, then install the package
    new_resource.extension_list.each do |raw_extension|
        extension = format(raw_extension, {version: new_resource.version})
        apt_package extension do
            action :install
        end
    end

    # Remove any package left-overs
    execute "Remove package leftovers" do
        command 'sudo apt-get autoremove -y'
    end
end

action :configure do
    ["cli", "fpm"].each do |type|
        template "#{type}" do
            source "php.ini.erb"
            path "/etc/php/#{new_resource.version}/#{type}/php.ini"
            owner "root"
            group "root"
            mode "644"
            variables({
                timezone: "#{new_resource.configuration[:timezone]}",
                memory_limit: "#{new_resource.configuration[:memory_limit]}",
                upload_max_filesize: "#{new_resource.configuration[:upload_max_filesize]}",
                max_execution_time: "#{new_resource.configuration[:max_execution_time]}",
                zlib_output_compression: "#{new_resource.configuration[:zlib_output_compression]}"
            })
        end
        if type == "fpm"
            template "#{type}" do
                source "www.conf.erb"
                path "/etc/php/#{new_resource.version}/#{type}/pool.d/www.conf"
                owner "root"
                group "root"
                mode "644"
                variables({
                    owner: "#{new_resource.vm_user}",
                    user: "#{new_resource.vm_user}",
                    group: "#{new_resource.vm_user}",
                    backend: "#{new_resource.configuration[:backend]}",
                    port: "#{new_resource.configuration[:port]}"
                })
            end
        end
    end

    # Set up script to run php as VM user
    template "Run PHP as #{new_resource.vm_user}" do
        source "php.sh.erb"
        path "/bin/php.sh"
        owner "root"
        group "root"
        mode "644"
        variables({ 
            user: "#{new_resource.vm_user}",
            version: "#{new_resource.version}" 
        })
    end
end

action :set_user do
    if new_resource.php_user != "www-data"
        link "/usr/bin/php" do
            to "/etc/alternatives/php"
            action :delete
        end
        
        link "/usr/bin/php" do
            to "/bin/php.sh"
            action :create
        end
        
        execute "Make PHP script executable" do
            command "sudo chmod +x /bin/php.sh"
        end
    else
        link "/usr/bin/php" do
            to "/bin/php.sh"
            action :delete
        end
        
        link "/usr/bin/php" do
            to "/etc/alternatives/php"
            action :create
        end
        
        execute "Make PHP script non-executable" do
            command "sudo chmod -x /bin/php.sh"
            only_if { ::File.exist?("/bin/php.sh") }
        end
    end
end

action :configure_sendmail do
    ["cli", "fpm"].each do |php_type|
        ruby_block "#{new_resource.name}" do
            block do
                StringReplaceHelper.set_php_sendmail_path("#{php_type}", "#{new_resource.version}", "#{new_resource.sendmail_path}")
            end
            only_if { ::File.exist?("/etc/php/#{new_resource.version}/#{php_type}/php.ini") }
        end
    end
end

action :enable do
    service "php#{new_resource.version}-fpm" do
        action :enable
    end
end

action :restart do
    service "php#{new_resource.version}-fpm" do
        action :restart
    end
end