# Cookbook:: magento
# Resource:: magento_cli
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :magento_cli
provides :magento_cli

property :name, String, name_property: true
property :web_root, String, default: node[:magento][:nginx][:web_root]
property :user, String, default: node[:magento][:init][:user]
property :install_string, String
property :config_path, String
property :config_value, [String, Integer, TrueClass, FalseClass]
property :config_scope, String, default: 'default'
property :config_scope_code, String, default: ''
property :deploy_mode,
         String,
         default: node[:magento][:build][:deploy_mode][:mode]
property :modules, Array, default: []
property :cache_types, Array, default: []
property :indexers, Array, default: []
property :indexer_mode, String, default: 'schedule'
property :admin_username, String
property :admin_password, String
property :admin_email, String
property :admin_firstname, String
property :admin_lastname, String
property :command_list, [String, Array]

action :install do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento setup:install #{new_resource.install_string}'"
		cwd new_resource.web_root
	end
end

action :clean_cache do
	cache_types = new_resource.cache_types.join(' ') unless new_resource
		.cache_types.empty?
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento cache:clean #{cache_types}'"
		cwd new_resource.web_root
	end
end

action :reindex do
	indexers = new_resource.indexers.join(' ') unless new_resource.indexers.empty?
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento indexer:reindex #{indexers}'"
		retries 2
		cwd new_resource.web_root
	end
end

action :reset_indexers do
	indexers = new_resource.indexers.join(' ') unless new_resource.indexers.empty?
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento indexer:reset #{indexers}'"
		cwd new_resource.web_root
	end
end

action :deploy_sample_data do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento sampledata:deploy'"
		cwd new_resource.web_root
	end
end

action :enable_modules do
	modules = new_resource.modules.join(' ') unless new_resource.modules.empty?
	execute 'Enabling modules' do
		command "su #{new_resource.user} -c 'bin/magento module:enable #{modules}'"
		cwd new_resource.web_root
	end
end

action :disable_modules do
	modules = new_resource.modules.join(' ') unless new_resource.modules.empty?
	execute 'Disabling modules' do
		command "su #{new_resource.user} -c 'bin/magento module:disable #{modules}'"
		cwd new_resource.web_root
	end
end

action :db_upgrade do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento setup:upgrade'"
		cwd new_resource.web_root
	end
end

action :di_compile do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento setup:di:compile'"
		cwd new_resource.web_root
	end
end

action :deploy_static_content do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento setup:static-content:deploy -f'"
		cwd new_resource.web_root
	end
end

action :set_application_mode do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento deploy:mode:set #{new_resource.deploy_mode}'"
		cwd new_resource.web_root
	end
end

action :set_indexer_mode do
	indexers = new_resource.indexers.join(' ') unless new_resource.indexers.empty?
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento indexer:set-mode #{new_resource.indexer_mode} #{indexers}'"
		cwd new_resource.web_root
	end
end

action :enable_cron do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento cron:install'"
		cwd new_resource.web_root
	end
end

action :run_cron do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento cron:run'"
		cwd new_resource.web_root
	end
end

action :disable_cron do
	execute new_resource.name do
		command "crontab -r -u #{new_resource.user}"
	end
end

action :config_set do
	command_string = "su #{new_resource.user} -c 'bin/magento config:set"
	scope_string = "--scope=\"#{new_resource.config_scope}\""
	unless new_resource.config_scope_code.nil?
		scope_string =
			[scope_string, "--scope-code=\"#{new_resource.config_scope_code}\""].join(
				' ',
			)
	end
	config_string =
		"\"#{new_resource.config_path}\" \"#{ValueHelper.process_value(new_resource.config_value)}\"'"
	execute new_resource.name do
		command [command_string, scope_string, config_string].join(' ')
		cwd new_resource.web_root
	end
end

action :disable_maintenance_mode do
	execute new_resource.name do
		command "su #{new_resource.user} -c 'bin/magento maintenance:disable'"
		cwd new_resource.web_root
	end
end

action :run do
	command_list = []
	if new_resource.command_list.is_a?(String)
		command_list << new_resource.command_list
	else
		command_list = new_resource.command_list
	end
	command_list.each do |command|
		execute "Running the #{command} Magento CLI command" do
			command "su #{new_resource.user} -c './bin/magento #{command}'"
			cwd new_resource.web_root
		end
	end
end
