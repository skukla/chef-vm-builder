#
# Cookbook:: magento
# Resource:: magento_app
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_app
provides :magento_app

property :name,                     String,                  name_property: true
property :web_root,                 String,                  default: node[:magento][:init][:web_root]
property :composer_file,            String,                  default: node[:magento][:composer][:file]
property :composer_public_key,      String,                  default: node[:magento][:composer][:public_key]
property :composer_private_key,     String,                  default: node[:magento][:composer][:private_key]
property :composer_github_token,    String,                  default: node[:magento][:composer][:github_token]
property :permission_dirs,          Array,                   default: ['var/', 'pub/', 'app/etc/', 'generated/']
property :user,                     String,                  default: node[:magento][:init][:user]
property :group,                    String,                  default: node[:magento][:init][:user]
property :family,                   String,                  default: node[:magento][:options][:family]
property :version,                  String,                  default: node[:magento][:options][:version]
property :modules_to_remove,        [String, Array],         default: node[:magento][:build][:modules_to_remove]
property :use_elasticsearch,        [TrueClass, FalseClass], default: node[:magento][:elasticsearch][:use]
property :elasticsearch_host,       String,                  default: node[:magento][:elasticsearch][:host]
property :elasticsearch_port,       [String, Integer],       default: node[:magento][:elasticsearch][:port]
property :db_host,                  String,                  default: node[:magento][:mysql][:db_host]
property :db_user,                  String,                  default: node[:magento][:mysql][:db_user]
property :db_password,              String,                  default: node[:magento][:mysql][:db_password]
property :db_name,                  String,                  default: node[:magento][:mysql][:db_name]
property :install_settings,         Hash
property :consumer_list,            Array, default: node[:magento][:options][:consumer_list]
property :cache_types,              Array
property :indexers,                 Array
property :remove_generated,         [TrueClass, FalseClass], default: true

action :download do
  composer new_resource.name.to_s do
    action :install
  end
end

action :install do
  install_string = "--db-host=#{new_resource.db_host} --db-name=#{new_resource.db_name} --db-user=#{new_resource.db_user} --db-password=#{new_resource.db_password} --backend-frontname=#{new_resource.install_settings[:backend_frontname]} --base-url=#{new_resource.install_settings[:unsecure_base_url]} --language=#{new_resource.install_settings[:language]} --timezone=#{new_resource.install_settings[:timezone]} --currency=#{new_resource.install_settings[:currency]} --admin-firstname=#{new_resource.install_settings[:admin_firstname]} --admin-lastname=#{new_resource.install_settings[:admin_lastname]} --admin-email=#{new_resource.install_settings[:admin_email]} --admin-user=#{new_resource.install_settings[:admin_user]} --admin-password=#{new_resource.install_settings[:admin_password]}"
  elasticsearch_string = "--elasticsearch-host=#{new_resource.elasticsearch_host} --elasticsearch-port=#{new_resource.elasticsearch_port}"
  rewrites_string = "--use-rewrites=#{ValueHelper.process_value(new_resource.install_settings[:use_rewrites])}"
  use_secure_frontend_string = "--use-secure=#{ValueHelper.process_value(new_resource.install_settings[:use_secure_frontend])}"
  use_secure_admin_string = "--use-secure-admin=#{ValueHelper.process_value(new_resource.install_settings[:use_secure_admin])}"
  secure_url_string = "--base-url-secure=#{new_resource.install_settings[:secure_base_url]}"
  cleanup_database_string = '--cleanup-database'
  session_save_string = "--session-save=#{new_resource.install_settings[:session_save]}"
  encryption_key_string = "--key=#{new_resource.install_settings[:encryption_key]}"

  # Create the master install string
  install_string = [install_string, rewrites_string].join(' ') if new_resource.install_settings[:use_rewrites]
  if new_resource.use_elasticsearch && VersionHelper.check_version(new_resource.version, '>=', '2.4.0')
    install_string = [install_string, elasticsearch_string].join(' ')
  end
  if new_resource.install_settings[:use_secure_admin]
    install_string = [install_string, use_secure_admin_string].join(' ')
  end
  if new_resource.install_settings[:use_secure_frontend]
    install_string = [install_string, use_secure_frontend_string].join(' ')
  end
  if new_resource.install_settings[:use_secure_frontend] || new_resource.install_settings[:use_secure_admin]
    install_string = [install_string, secure_url_string].join(' ')
  end
  install_string = [install_string, cleanup_database_string] if new_resource.install_settings[:cleanup_database]
  install_string = [install_string, session_save_string].join(' ')
  unless new_resource.install_settings[:encryption_key].nil? || new_resource.install_settings[:encryption_key].empty?
    install_string = [install_string, encryption_key_string].join(' ')
  end

  magento_cli 'Install via the Magento CLI' do
    action :install
    install_string install_string
  end
end

action :update do
  composer new_resource.name do
    action :update
  end
end

action :set_auth_credentials do
  template new_resource.name.to_s do
    source 'auth.json.erb'
    path "/home/#{new_resource.user}/.composer/auth.json"
    owner new_resource.user
    group new_resource.group
    mode '664'
    variables({
                public_key: new_resource.composer_public_key,
                private_key: new_resource.composer_private_key,
                github_token: new_resource.composer_github_token
              })
  end
end

action :add_sample_data do
  directory 'Create composer_home directory' do
    path "#{new_resource.web_root}/var/composer_home"
    owner new_resource.user
    group new_resource.group
    mode '0777'
    not_if { ::Dir.exist?("#{new_resource.web_root}/var/composer_home") }
  end

  execute 'Copy auth.json into place' do
    command "cp /home/#{new_resource.user}/.#{new_resource.composer_file}/auth.json #{new_resource.web_root}/var/composer_home/"
    only_if { ::File.exist?("/home/#{new_resource.user}/.#{new_resource.composer_file}/auth.json") }
  end

  file 'Set auth.json permissions' do
    path "#{new_resource.web_root}/var/composer_home/auth.json"
    owner new_resource.user
    group new_resource.group
    mode '0777'
    only_if { ::File.exist?("#{new_resource.web_root}/var/composer_home/auth.json") }
  end

  magento_cli 'Download sample data' do
    action :deploy_sample_data
  end
end

action :update_version do
  ruby_block new_resource.name do
    block do
      StringReplaceHelper.update_app_version(
        new_resource.user,
        new_resource.version,
        new_resource.family,
        new_resource.web_root,
        'composer.json'
      )
    end
  end
end

action :db_upgrade do
  magento_cli new_resource.name do
    action :db_upgrade
  end
end

action :di_compile do
  magento_cli new_resource.name do
    action :di_compile
  end
end

action :deploy_static_content do
  magento_cli new_resource.name do
    action :deploy_static_content
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

action :remove_modules do
  ruby_block new_resource.name.to_s do
    block do
      StringReplaceHelper.remove_modules(
        new_resource.modules_to_remove,
        "#{new_resource.web_root}/composer.json"
      )
    end
  end
end

action :set_application_mode do
  magento_cli new_resource.name do
    action :set_application_mode
  end
end

action :set_indexer_mode do
  magento_cli new_resource.name do
    action :set_indexer_mode
    indexers new_resource.indexers
  end
end

action :reset_indexers do
  magento_cli new_resource.name do
    action :reset_indexers
    indexers new_resource.indexers
  end
end

action :reindex do
  magento_cli new_resource.name do
    action :reindex
    indexers new_resource.indexers
  end
end

action :clean_cache do
  magento_cli new_resource.name do
    action :clean_cache
    cache_types new_resource.cache_types
  end
end

action :enable_cron do
  magento_cli new_resource.name do
    action :enable_cron
  end
end

action :disable_cron do
  magento_cli new_resource.name do
    action :disable_cron
  end
end

action :clear_cron_schedule do
  ruby_block 'Clear the cron schedule table' do
    block do
      `mysql -uroot -e "USE #{new_resource.db_name};DELETE FROM cron_schedule;"`
    end
    action :create
  end
end

action :start_consumers do
  magento_cli new_resource.name do
    action :start_consumers
    consumer_list new_resource.consumer_list
  end
end

action :disable_maintenance_mode do
  magento_cli new_resource.name do
    action :disable_maintenance_mode
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

action :uninstall do
  vm_cli 'Clearing the web root' do
    action :run
    command_list 'clear-web-root'
  end
end
