# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :composer
property :name,         String, name_property: true
property :install_dir,  String, default: node[:composer][:install_dir]
property :filename,     String, default: node[:composer][:filename]
property :user,         String, default: node[:composer][:user]
property :group,        String, default: node[:composer][:user]
property :timeout,      Integer

action :download do
    execute "Download composer" do
        command "curl -sS https://getcomposer.org/installer | php"
        not_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.filename}") }
    end
end

action :install_app do
    execute "Install composer application" do
        command "mv #{new_resource.filename}.phar /#{new_resource.install_dir}/#{new_resource.filename} && chmod +x /#{new_resource.install_dir}/#{new_resource.filename}"
        not_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.filename}") }
    end
    
    execute "Switch composer owner to #{new_resource.user}" do
        command "sudo chown #{new_resource.user}:#{new_resource.user} #{new_resource.install_dir}/#{new_resource.filename}"
        only_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.filename}") }
    end

    # Make composer accessible globally
    link "/home/#{new_resource.user}/#{new_resource.filename}" do
        to "/#{new_resource.install_dir}/#{new_resource.filename}"
        owner "#{new_resource.user}"
        group "#{new_resource.user}"
        not_if "test -L /#{new_resource.install_dir}/#{new_resource.filename}"
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
        command "su #{new_resource.user} -c '#{new_resource.install_dir}/#{new_resource.filename} clearcache'"
        only_if { ::File.exist?("#{new_resource.install_dir}/#{new_resource.filename}") }
    end
end