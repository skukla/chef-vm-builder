#
# Cookbook:: magento
# Resource:: magento_cli 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_cli
property :name,               String, name_property: true
property :web_root,           String, default: node[:magento][:web_root]
property :user,               String, default: node[:magento][:user]
property :install_string,     String
property :config_path,        String
property :config_value,       String
property :config_scope,       String
property :config_scope_code,  String
property :deploy_mode,        String, default: node[:magento][:installation][:build][:deploy_mode][:mode]
property :cache_types,        Array, default: Array.new
property :indexers,           Array, default: Array.new
property :admin_username,     String
property :admin_password,     String
property :admin_email,        String
property :admin_firstname,    String
property :admin_lastname,     String

action :install do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento setup:install #{new_resource.install_string}'"
    end
end

action :clean_cache do
    cache_types = new_resource.cache_types.join(" ") unless new_resource.cache_types.empty?
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento cache:clean #{cache_types}'"
    end
end

action :reindex do
    indexers = new_resource.indexers.join(" ") unless new_resource.indexers.empty?
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento indexer:reindex #{indexers}'"
    end
end

action :reset_indexers do
    indexers = new_resource.indexers.join(" ") unless new_resource.indexers.empty?
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento indexer:reset #{indexers}'"
    end
end

action :deploy_sample_data do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento sampledata:deploy'"
    end
end

action :db_upgrade do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento setup:upgrade'"
    end
end

action :di_compile do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento setup:di:compile'"
    end
end

action :deploy_static_content do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento setup:static-content:deploy'"
    end
end

action :set_application_mode do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento deploy:mode:set #{deploy_mode}'"
    end
end

action :set_indexer_mode do
    indexers = new_resource.indexers.join(" ") unless new_resource.indexers.empty?
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento indexer:set-mode schedule #{indexers}'"
    end
end

action :disable_cron do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c 'crontab -r'"
    end
end

action :enable_cron do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento cron:install'"
    end
end

action :config_set do
    command_string = "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento config:set"
    scope_string = "--scope=\"#{new_resource.config_scope}\" --scope-code=\"#{new_resource.config_scope_code}\""
    config_string = "#{new_resource.config_path} #{new_resource.config_value}"
    execute "#{new_resource.name}" do
        command [command_string, scope_string, config_string].join(" ")
    end
end

action :create_admin_user do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.web_root}/bin/magento admin:user:create --admin-user=#{new_resource.admin_username} --admin-password=#{new_resource.admin_password} --admin-email=#{new_resource.admin_email} --admin-firstname=#{new_resource.admin_firstname} --admin-lastname=#{new_resource.admin_lastname}'"
    end
end