# Cookbook:: composer
# Resource:: composer
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :composer
provides :composer

property :name, String, name_property: true
property :install_directory, String, default: node[:composer][:install_dir]
property :file, String, default: node[:composer][:file]
property :version, String, default: node[:composer][:version]
property :user, String, default: node[:composer][:init][:user]
property :group, String, default: node[:composer][:init][:user]
property :web_root, String, default: node[:composer][:nginx][:web_root]
property :options, Array
property :project_name, String
property :project_directory, String
property :project_stability,
         String,
         default: node[:composer][:magento][:project_stability]
property :package_name, String
property :package_version, String
property :module_name, String
property :repository_url, String, default: ''
property :extra_content, String
property :setting, String
property :value, [String, Integer, TrueClass, FalseClass]

action :install_app do
  install_string =
    "--install-dir=#{new_resource.install_directory} --filename=#{new_resource.file}"
  version_string = "--version=#{new_resource.version}" if new_resource
    .version != 'latest'
  install_string = [install_string, version_string].join(' ')

  bash "Download composer version #{new_resource.version}" do
    code <<-CONTENT
            EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
            ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
            if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
            then
                >&2 echo 'ERROR: Invalid installer checksum'
                rm composer-setup.php
                exit 1
            fi
            php composer-setup.php --quiet #{install_string}
            RESULT=$?
						rm composer-setup.php
            exit $RESULT
    CONTENT
  end

  file 'Adding composer version flag' do
    content new_resource.version
    path "/home/#{new_resource.user}/.composer-version"
    action :create
    owner new_resource.user
    group new_resource.group
  end
end

action :create_project do
  execute new_resource.name do
    options_string =
      new_resource.options.nil? ? '' : "--#{new_resource.options.join(' --')}"

    command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} create-project #{options_string} --stability #{new_resource.project_stability} --repository-url=#{new_resource.repository_url} #{new_resource.project_name}:#{new_resource.package_version} #{new_resource.project_directory}'"
    cwd new_resource.project_directory
  end
end

action :set_project_stability do
  ruby_block new_resource.name do
    block do
      StringReplaceHelper.set_project_stability(
        new_resource.project_stability,
        "#{new_resource.web_root}/composer.json",
      )
    end
  end
end

action :update_sort_packages do
  ruby_block new_resource.name do
    block do
      StringReplaceHelper.update_sort_packages(
        "#{new_resource.web_root}/composer.json",
      )
    end
  end
end

action :add_repository do
  execute new_resource.name do
    command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} config repositories.#{new_resource.module_name} git #{new_resource.repository_url}'"
    cwd new_resource.web_root
  end
end

action :require do
  options_string =
    new_resource.options.nil? ? '' : "--#{new_resource.options.join(' --')}"

  command_string =
    [
      "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} require",
      options_string,
      "#{new_resource.package_name}'",
    ].join(' ')

  execute new_resource.name do
    command command_string
    cwd new_resource.web_root
  end
end

action :install do
  execute new_resource.name do
    command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} install'"
    cwd new_resource.web_root
  end
end

action :update do
  options_string =
    new_resource.options.nil? ? '' : "--#{new_resource.options.join(' --')}"

  execute new_resource.name do
    command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} update #{options_string}'"
    cwd new_resource.web_root
  end
end

action :config do
  options_string =
    new_resource.options.nil? ? '' : "--#{new_resource.options.join(' --')}"

  execute new_resource.name do
    command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} config #{options_string} #{new_resource.setting} #{new_resource.value}'"
  end
end

action :clear_cache do
  execute new_resource.name do
    command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} clearcache'"
  end
end

action :uninstall do
  file 'Remove Composer file' do
    path "#{new_resource.install_directory}/#{new_resource.file}"
    action :delete
    only_if do
      ::File.exist?("#{new_resource.install_directory}/#{new_resource.file}")
    end
  end

  execute 'Remove composer version flag' do
    command "sudo rm -rf /home/#{new_resource.user}/.composer-version"
  end
end
