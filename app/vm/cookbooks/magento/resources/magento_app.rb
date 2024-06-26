# Cookbook:: magento
# Resource:: magento_app
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :magento_app
provides :magento_app

property :name, String, name_property: true
property :web_root, String, default: node[:magento][:nginx][:web_root]
property :composer_file, String, default: node[:magento][:composer][:file]
property :composer_public_key, String, default: node[:composer][:public_key]
property :composer_private_key, String, default: node[:composer][:private_key]
property :composer_github_token, String, default: node[:composer][:github_token]
property :permission_dirs, Array, default: %w[var/ pub/ app/etc/ generated/]
property :user, String, default: node[:magento][:init][:user]
property :group, String, default: node[:magento][:init][:user]
property :family, String, default: node[:magento][:options][:family]
property :version, String, default: node[:magento][:options][:version]
property :build_action, String, default: node[:magento][:build][:action]
property :sample_data_module_list,
         Array,
         default: node[:magento][:magento_modules][:sample_data_module_list]
property :repositories_to_remove,
         [String, Array],
         default: node[:magento][:magento_modules][:repositories_to_remove_list]
property :modules_to_remove,
         [String, Array],
         default: node[:magento][:magento_modules][:modules_to_remove_list]
property :search_engine_type,
         String,
         default: node[:magento][:search_engine][:type]
property :elasticsearch_host,
         String,
         default: node[:magento][:search_engine][:host][:value]
property :elasticsearch_port,
         String,
         default: node[:magento][:search_engine][:port][:value]
property :elasticsearch_prefix,
         String,
         default: node[:magento][:search_engine][:prefix][:value]
property :db_host, String, default: node[:magento][:mysql][:db_host]
property :db_user, String, default: node[:magento][:mysql][:db_user]
property :db_password, String, default: node[:magento][:mysql][:db_password]
property :db_name, String, default: node[:magento][:mysql][:db_name]
property :install_settings, Hash
property :remove_generated, [TrueClass, FalseClass], default: true

action :set_auth_credentials do
  composer 'Adding credentials' do
    action :config
    setting 'http-basic.repo.magento.com'
    value "#{new_resource.composer_public_key} \ #{new_resource.composer_private_key}"
    options %w[global auth]
  end

  composer 'Adding OAuth token' do
    action :config
    setting 'github-oauth.github.com'
    value new_resource.composer_github_token
    options %w[global auth]
  end
end

action :install do
  magento_cli 'Install via the Magento CLI' do
    action :install
    install_string MagentoHelper.build_install_string(
                     new_resource.build_action,
                     new_resource.version,
                     new_resource.search_engine_type,
                     {
                       db_host: new_resource.db_host,
                       db_user: new_resource.db_user,
                       db_name: new_resource.db_name,
                       db_password: new_resource.db_password,
                     },
                     new_resource.install_settings,
                   )
  end
end

action :add_sample_data_media do
  execute 'Adding sample data media' do
    command 'cp -R vendor/magento/sample-data-media/* pub/media/'
    cwd new_resource.web_root
  end
end

action :set_permissions do
  new_resource.permission_dirs.each do |directory|
    execute "Update #{directory} permissions" do
      command "chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.web_root}/#{directory} && chmod -R 777 #{new_resource.web_root}/#{directory}"
      only_if { ::Dir.exist?("#{new_resource.web_root}/#{directory}") }
    end
  end
  if new_resource.remove_generated == true
    generated_directory = "#{new_resource.web_root}/generated"
    generated_content = ::Dir.entries(generated_directory) - %w[. ..]
    generated_content_string = []
    generated_content.each do |entry|
      generated_content_string << "#{generated_directory}/#{entry}"
    end
    execute 'Clear the generated directory' do
      command "rm -rf #{generated_content_string.join(' ')}"
      only_if { ::Dir.exist?(generated_directory) }
    end
  end
end

action :remove_repositories do
  new_resource.repositories_to_remove.each do |md|
    composer 'Removing repositories' do
      action :remove_repository
      repository_key md.source
    end
  end
end

action :remove_modules do
  ruby_block 'Inserting replace block' do
    block do
      StringReplaceHelper.remove_modules(
        new_resource.modules_to_remove,
        "#{new_resource.web_root}/composer.json",
      )
    end
  end
end

action :clear_cron_schedule do
  mysql 'Clear the cron schedule table' do
    DatabaseHelper.execute_query(
      'DELETE FROM cron_schedule',
      new_resource.db_name,
    )
  end
end

action :set_first_run do
  template new_resource.name do
    source '.first-run-state.flag.erb'
    path "#{new_resource.web_root}/var/.first-run-state.flag"
    owner new_resource.user
    group new_resource.group
    mode '664'
  end
end

action :remove_env_file do
  execute 'Remove app/etc/env.php' do
    command 'rm -rf app/etc/env.php'
    cwd new_resource.web_root
  end
end

action :prepare_reinstall do
  if MagentoHelper.admin_user_exists?
    result =
      DatabaseHelper.execute_query(
        "DELETE FROM admin_user WHERE username = 'admin'",
        DatabaseHelper.db_name,
      )
    pp 'Deleted the admin user from the database'
  end
end

action :prepare_restore do
  directory 'Create pub/static directory' do
    path "#{new_resource.web_root}/pub/static"
    owner new_resource.user
    group new_resource.group
    mode '0777'
  end
end
