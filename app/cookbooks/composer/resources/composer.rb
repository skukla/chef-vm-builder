#
# Cookbook:: composer
# Resource:: composer 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :composer
provides :composer

property :name,                 String, name_property: true
property :install_directory,    String, default: node[:composer][:install_dir]
property :file,                 String, default: node[:composer][:file]
property :user,                 String, default: node[:composer][:user]
property :group,                String, default: node[:composer][:user]
property :web_root,             String, default: node[:composer][:web_root]
property :options,              Array
property :project_name,         String
property :project_directory,    String
property :project_stability,    String, default: node[:composer][:project_stability]
property :package_name,         String
property :package_version,      String
property :module_name,          String
property :repository_url,       String
property :extra_content,        String
property :timeout,              Integer

action :download_app do
    execute "Download composer" do
        command "curl -sS https://getcomposer.org/installer | php"
        not_if { ::File.exist?("#{new_resource.install_directory}/#{new_resource.file}") }
    end
end

action :install_app do
    execute "Install composer application" do
        command "mv #{new_resource.file}.phar #{new_resource.install_directory}/#{new_resource.file} && chmod +x #{new_resource.install_directory}/#{new_resource.file}"
        not_if { ::File.exist?("#{new_resource.install_directory}/#{new_resource.file}") }
    end
    
    execute "Switch composer owner to #{new_resource.user}" do
        command "sudo chown #{new_resource.user}:#{new_resource.user} #{new_resource.install_directory}/#{new_resource.file}"
        only_if { ::File.exist?("#{new_resource.install_directory}/#{new_resource.file}") }
    end

    link "/home/#{new_resource.user}/#{new_resource.file}" do
        to "/#{new_resource.install_directory}/#{new_resource.file}"
        owner "#{new_resource.user}"
        group "#{new_resource.user}"
        not_if "test -L /#{new_resource.install_directory}/#{new_resource.file}"
    end
end

action :configure_app do
    directory "#{new_resource.user} .composer directory" do
        path "/home/#{new_resource.user}/.composer"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "775"
        not_if { ::File.directory?("/home/#{new_resource.user}/.composer") }
    end

    template 'Composer configuration' do
        source 'config.json.erb'
        path "/home/#{new_resource.user}/.composer/config.json"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "644"
        variables({ timeout: "#{new_resource.timeout}" })
    end
end

action :create_project do
    execute "#{new_resource.name}" do
        options_string = "--#{new_resource.options.join(" --")}" if !new_resource.options.nil?
        command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} create-project #{options_string} --stability #{new_resource.project_stability} --repository-url=#{new_resource.repository_url} #{new_resource.project_name}:#{new_resource.package_version} #{new_resource.web_root}'"
        cwd "#{new_resource.web_root}"
    end
end

action :set_project_stability do
    ruby_block "#{new_resource.name}" do
        block do
            StringReplaceHelper.set_project_stability("#{new_resource.project_stability}", "#{new_resource.web_root}/composer.json")
        end
    end
end

action :update_sort_packages do
    ruby_block "#{new_resource.name}" do
        block do
            StringReplaceHelper.update_sort_packages("#{new_resource.web_root}/composer.json")
        end
    end
end

action :add_repository do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} config repositories.#{new_resource.module_name} git #{new_resource.repository_url}'"
        cwd "#{new_resource.web_root}"
    end
end

action :require do
    options_string = "--#{new_resource.options.join(" --")}" if !new_resource.options.nil?
    if !new_resource.package_version.nil? && !new_resource.package_version.empty?
        package_string = [new_resource.package_name, new_resource.package_version].join(":")
    else
        package_string = new_resource.package_name
    end
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} require #{options_string} #{package_string}'"
        cwd "#{new_resource.web_root}"
    end
end
    
action :install do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} install'"
        cwd "#{new_resource.web_root}"
    end
end

action :update do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} update'"
        cwd "#{new_resource.web_root}"
    end
end

action :clearcache do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} clearcache'"
    end
end

action :config_extra do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.install_directory}/#{new_resource.file} config extra.patches-file #{new_resource.extra_content}'"
        cwd "#{new_resource.web_root}"
    end
end
