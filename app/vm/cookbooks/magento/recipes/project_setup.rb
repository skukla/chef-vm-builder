# Cookbook:: magento
# Recipe:: project_setup
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

user = node[:magento][:init][:user]
group = node[:magento][:init][:user]
tmp_dir = node[:magento][:nginx][:tmp_dir]
web_root = node[:magento][:nginx][:web_root]
version = node[:magento][:options][:version]
family = node[:magento][:options][:family]
build_action = node[:magento][:build][:action]
install_dir =
	%w[update_all update_app].include?(build_action) ? tmp_dir : web_root
tmp_composer_json = "#{tmp_dir}/composer.json"
composer_json = "#{web_root}/composer.json"

if %w[update_all update_app].include?(build_action)
	execute 'Clearing the temporary download directory' do
		command "rm -rf #{tmp_dir}/*"
		only_if { ::File.exist?("#{web_root}/composer.json") }
	end
end

if %w[install force_install update_all update_app].include?(build_action)
	composer "Create Magento #{family.capitalize} #{version} project" do
		action :create_project
		repository_url 'https://repo.magento.com/'
		options %w[no-install]
		package_version version
		project_name "magento/project-#{family}-edition"
		project_directory install_dir
	end
end

if %w[update_all update_app].include?(build_action)
	execute 'Moving composer.json into web root' do
		command "mv #{tmp_composer_json} #{composer_json}"
		only_if { ::File.exist?(tmp_composer_json) }
	end
end

if %w[install force_install update_all update_app].include?(build_action)
	composer 'Set the project stability and update sort-packages setting' do
		action :set_project_stability
		only_if { ::File.exist?(composer_json) }
	end

	magento_app 'Remove outdated modules' do
		action :remove_modules
		only_if do
			::File.exist?(composer_json) &&
				::File.foreach(composer_json).grep(/replace/).none?
		end
	end

	if family == 'enterprise'
		composer 'Require the B2B modules' do
			action :require
			package_name 'magento/extension-b2b'
			package_version '^1.0'
			options %w[no-update]
			only_if do
				::File.exist?(composer_json) &&
					::File.foreach(composer_json).grep(%r{magento/extension-b2b}).none?
			end
		end
	end
end
