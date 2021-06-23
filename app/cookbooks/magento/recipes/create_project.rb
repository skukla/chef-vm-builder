#
# Cookbook:: magento
# Recipe:: create_project
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:nginx][:web_root]
version = node[:magento][:options][:version]
family = node[:magento][:options][:family]
build_action = node[:magento][:build][:action]
composer_json = "#{web_root}/composer.json"

if %w[install force_install].include?(build_action)
  composer "Create Magento #{family.capitalize} #{version} project" do
    action :create_project
    repository_url 'https://repo.magento.com/'
    options ['no-install']
    package_version version
    project_name "magento/project-#{family}-edition"
    project_directory web_root
  end

  if build_action == 'update'
    magento_app 'Update the Magento version' do
      action :update_version
      only_if do
        ::File.exist?(composer_json) &&
          ::File.foreach(composer_json).grep(/#{version}/).none?
      end
    end
  end

  if %w[install force_install update].include?(build_action)
    composer 'Set the project stability and update sort-packages setting' do
      action %i[set_project_stability update_sort_packages]
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
        options ['no-update']
        only_if do
          ::File.exist?(composer_json) &&
            ::File.foreach(composer_json).grep(%r{magento/extension-b2b}).none?
        end
      end
    end
  end
end
