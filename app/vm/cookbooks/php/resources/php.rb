#
# Cookbook:: php
# Resource:: php
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :php
provides :php

property :name, String, name_property: true
property :php_user, String, default: node[:php][:user]
property :vm_user, String, default: node[:php][:init][:user]
property :vm_group, String, default: node[:php][:init][:user]
property :version, String, default: node[:php][:version]
property :port, [String, Integer], default: node[:php][:port]
property :max_execution_time,
         [String, Integer],
         default: node[:php][:max_execution_time]
property :memory_limit, String, default: node[:php][:memory_limit]
property :upload_max_filesize, String, default: node[:php][:upload_max_filesize]
property :zlib_output_compression,
         String,
         default: node[:php][:zlib_output_compression]
property :backend, String, default: node[:php][:backend]
property :extension_list, Array, default: node[:php][:extension_list]
property :sendmail_path, String, default: node[:php][:sendmail_path]
property :timezone, String, default: node[:php][:init][:timezone]
property :apache_package_list, Array, default: node[:php][:apache_package_list]
property :web_root, String, default: node[:php][:nginx][:web_root]
property :command_list, [String, Array]

action :install do
	# Add PHP repository
	apt_repository "php-#{new_resource.version}" do
		uri 'ppa:ondrej/php'
		components ['main']
		distribution 'bionic'
		action :add
		retries 3
		not_if do
			::File.exist?("/etc/apt/sources.list.d/php-#{new_resource.version}.list")
		end
	end

	# Install specified PHP and extensions
	# Use string replacement to inject the PHP version, then install the package
	new_resource.extension_list.each do |raw_extension|
		extension = format(raw_extension, { version: new_resource.version })
		apt_package extension do
			action :install
		end
	end

	# Remove any package left-overs
	execute 'Remove package leftovers' do
		command 'apt-get autoremove -y'
	end
end

action :configure do
	%w[cli fpm].each do |type|
		template type do
			source 'php.ini.erb'
			path "/etc/php/#{new_resource.version}/#{type}/php.ini"
			owner 'root'
			group 'root'
			mode '644'
			variables(
				{
					timezone: new_resource.timezone,
					memory_limit: new_resource.memory_limit,
					upload_max_filesize: new_resource.upload_max_filesize,
					max_execution_time: new_resource.max_execution_time,
					zlib_output_compression: new_resource.zlib_output_compression,
				},
			)
		end
		next unless type == 'fpm'

		template type do
			source 'www.conf.erb'
			path "/etc/php/#{new_resource.version}/#{type}/pool.d/www.conf"
			owner 'root'
			group 'root'
			mode '644'
			variables(
				{
					owner: new_resource.vm_user,
					user: new_resource.vm_user,
					group: new_resource.vm_user,
					backend: new_resource.backend,
					port: new_resource.port,
				},
			)
		end
	end

	# Set up script to run php as VM user
	template "Run PHP as #{new_resource.vm_user}" do
		source 'php.sh.erb'
		path '/bin/php.sh'
		owner 'root'
		group 'root'
		mode '644'
		variables({ user: new_resource.vm_user, version: new_resource.version })
	end
end

action :set_user do
	if new_resource.php_user != 'www-data'
		link '/usr/bin/php' do
			to '/etc/alternatives/php'
			action :delete
		end

		link '/usr/bin/php' do
			to '/bin/php.sh'
			action :create
		end

		execute 'Make PHP script executable' do
			command 'chmod +x /bin/php.sh'
		end
	else
		link '/usr/bin/php' do
			to '/bin/php.sh'
			action :delete
		end

		link '/usr/bin/php' do
			to '/etc/alternatives/php'
			action :create
		end

		execute 'Make PHP script non-executable' do
			command 'chmod -x /bin/php.sh'
			only_if { ::File.exist?('/bin/php.sh') }
		end
	end
end

action :configure_sendmail do
	%w[cli fpm].each do |php_type|
		ruby_block new_resource.name do
			block do
				StringReplaceHelper.set_php_sendmail_path(
					php_type,
					new_resource.version,
					new_resource.sendmail_path,
				)
			end
			only_if do
				::File.exist?("/etc/php/#{new_resource.version}/#{php_type}/php.ini")
			end
		end
	end
end

action :remove_apache_packages do
	new_resource.apache_package_list.each do |package|
		apt_package package do
			action %i[remove purge]
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

action :stop do
	service "php#{new_resource.version}-fpm" do
		action :stop
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
		bash "Running the #{command} PHP command" do
			code <<-CONTENT
                php #{command}
      CONTENT
			cwd new_resource.web_root
		end
	end
end

action :uninstall do
	old_versions = Dir.entries('/etc/php') - %w[. ..]
	unless old_versions.empty?
		old_versions.each do |old_version|
			next unless old_version != new_resource.version

			package "php-#{old_version}" do
				action %i[purge remove]
			end

			new_resource.extension_list.each do |raw_extension|
				extension = format(raw_extension, { version: old_version })
				package extension do
					action %i[purge remove]
				end
			end

			apt_repository "php-#{old_version}" do
				uri 'ppa:ondrej/php'
				components ['main']
				distribution 'bionic'
				action :remove
			end

			directory "Old PHP #{old_version} files" do
				path "/etc/php/#{old_version}"
				action :delete
				recursive true
			end
		end
	end
end
