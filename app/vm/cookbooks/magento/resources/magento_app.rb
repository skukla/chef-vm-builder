# Cookbook:: magento
# Resource:: magento_app
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :magento_app
provides :magento_app

property :name, String, name_property: true
property :web_root, String, default: node[:magento][:nginx][:web_root]
property :composer_file, String, default: node[:magento][:composer][:file]
property :composer_public_key,
         String,
         default: node[:magento][:composer][:public_key]
property :composer_private_key,
         String,
         default: node[:magento][:composer][:private_key]
property :composer_github_token,
         String,
         default: node[:magento][:composer][:github_token]
property :permission_dirs, Array, default: %w[var/ pub/ app/etc/ generated/]
property :user, String, default: node[:magento][:init][:user]
property :group, String, default: node[:magento][:init][:user]
property :family, String, default: node[:magento][:options][:family]
property :version, String, default: node[:magento][:options][:version]
property :build_action, String, default: node[:magento][:build][:action]
property :sample_data_module_list,
         Array,
         default: node[:magento][:build][:sample_data][:module_list]
property :sample_data_repository_url,
         String,
         default: node[:magento][:build][:sample_data][:repository_url]
property :modules_to_remove,
         [String, Array],
         default: node[:magento][:build][:modules_to_remove]
property :hypervisor, String, default: node[:magento][:init][:hypervisor]
property :search_engine_type,
         String,
         default: node[:magento][:search_engine][:type]
property :elasticsearch_host,
         String,
         default: node[:magento][:search_engine][:host]
property :elasticsearch_port,
         String,
         default: node[:magento][:search_engine][:port]
property :elasticsearch_prefix,
         String,
         default: node[:magento][:search_engine][:prefix]
property :db_host, String, default: node[:magento][:mysql][:db_host]
property :db_user, String, default: node[:magento][:mysql][:db_user]
property :db_password, String, default: node[:magento][:mysql][:db_password]
property :db_name, String, default: node[:magento][:mysql][:db_name]
property :install_settings, Hash
property :remove_generated, [TrueClass, FalseClass], default: true

action :set_auth_credentials do
	template new_resource.name.to_s do
		source 'auth.json.erb'
		path "/home/#{new_resource.user}/.composer/auth.json"
		owner new_resource.user
		group new_resource.group
		mode '664'
		variables(
			{
				public_key: new_resource.composer_public_key,
				private_key: new_resource.composer_private_key,
				github_token: new_resource.composer_github_token,
			},
		)
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

action :add_sample_data do
	require_str =
		ComposerHelper.build_require_string(new_resource.sample_data_module_list)
	composer "Adding sample data modules: #{require_str}" do
		action :require
		package_name require_str
		options %w[no-update]
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
		DatabaseHelper.execute_query('DELETE FROM cron_schedule')
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

action :prepare_reinstall do
	execute 'Remove app/etc/env.php' do
		command 'rm -rf app/etc/env.php'
		cwd new_resource.web_root
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
