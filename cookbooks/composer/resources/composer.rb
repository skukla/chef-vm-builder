# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :composer
property :name,         String, name_property: true
property :install_dir,  String, default: node[:composer][:install_dir]
property :file,         String, default: node[:composer][:file]
property :user,         String, default: node[:composer][:user]
property :group,        String, default: node[:composer][:user]
property :timeout,      Integer

action :download do
    execute "Download composer" do
        command "curl -sS https://getcomposer.org/installer | php"
        not_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.file}") }
    end
end

action :install_app do
    execute "Install composer application" do
        command "mv #{new_resource.file}.phar /#{new_resource.install_dir}/#{new_resource.file} && chmod +x /#{new_resource.install_dir}/#{new_resource.file}"
        not_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.file}") }
    end
    
    execute "Switch composer owner to #{new_resource.user}" do
        command "sudo chown #{new_resource.user}:#{new_resource.user} #{new_resource.install_dir}/#{new_resource.file}"
        only_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.file}") }
    end

    # Make composer accessible globally
    link "/home/#{new_resource.user}/#{new_resource.file}" do
        to "/#{new_resource.install_dir}/#{new_resource.file}"
        owner "#{new_resource.user}"
        group "#{new_resource.user}"
        not_if "test -L /#{new_resource.install_dir}/#{new_resource.file}"
    end
end

action :configure do
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

action :clearcache do
    execute "#{new_resource.name}" do
        command "su #{new_resource.user} -c '#{new_resource.install_dir}/#{new_resource.file} clearcache'"
        only_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.file}") }
    end
end