#
# Cookbook:: elasticsearch
# Resource:: elasticsearch 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :elasticsearch
provides :elasticsearch

property :name,                     String, name_property: true
property :user,                     String, default: node[:elasticsearch][:user]
property :group,                    String, default: node[:elasticsearch][:user]
property :version,                  String, default: node[:elasticsearch][:version]
property :configuration,            Hash

action :uninstall do
    execute 'Purge Elasticsearch package and configuration' do
        command "dpkg --purge --force-all elasticsearch"
    end
        
    ['/var/lib/elasticsearch', '/etc/elasticsearch'].each do |folder|
        execute "Manually remove Elasticsearch #{folder}" do
            command "rm -rf #{folder}"
            only_if { ::File.directory?("#{folder}") }
        end
    end
    
    execute "Manually remove the Elasticsearch sources file" do
        command "rm -rf /etc/apt/sources.list.d/elastic*"
        only_if "ls /etc/apt/sources.list.d/elastic*"
    end
end

action :install_app do
    execute "Add Elasticsearch #{new_resource.version} repository" do
        command "sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - && echo \"deb https://artifacts.elastic.co/packages/#{new_resource.version}/apt stable main\" | sudo tee -a /etc/apt/sources.list.d/elastic-#{new_resource.version}.list && sudo apt-get update -y"
        not_if { ::File.directory?('/etc/elasticsearch') }
    end
    
    apt_package 'elasticsearch' do
        action :install
        ignore_failure true
        retries 3
        not_if { ::File.directory?('/etc/elasticsearch') }
    end
end

action :install_plugins do
    unless new_resource.configuration[:plugin_list].empty?
        new_resource.configuration[:plugin_list].each do |plugin|
            execute "Install #{plugin} elasticsearch plugin" do
                command "cd /usr/share/elasticsearch && bin/elasticsearch-plugin install #{plugin}"
                only_if { ::File.directory?('/etc/elasticsearch') }
            end
        end
    end
end

action :configure_jvm_options do
    template "JVM Options" do
        source "jvm.options.erb"
        path "/etc/elasticsearch/jvm.options.d/jvm.options"
        user "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "644"
        variables({ memory: "#{new_resource.configuration[:memory]}" })
        only_if { ::File.directory?("/etc/elasticsearch/jvm.options.d") }
    end
end

action :configure_app do
    template "Elasticsearch Configuration" do
        source "elasticsearch.yml.erb"
        path "/etc/elasticsearch/elasticsearch.yml"
        user "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "644"
        variables({ 
            cluster_name: "#{new_resource.configuration[:cluster_name]}",
            node_name: "#{new_resource.configuration[:node_name]}",
            log_file_path: "#{new_resource.configuration[:log_file_path]}",
            port: "#{new_resource.configuration[:port]}"
        })
        only_if { ::File.directory?("/etc/elasticsearch") }
    end

    # Set ownership to Elasticsearch user and group
    directory "/etc/elasticsearch" do
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        recursive true
    end
end

action :restart do
    service "elasticsearch" do
        action :restart
        only_if { ::File.directory?('/etc/elasticsearch') }
    end
end

action :enable do
    service "elasticsearch" do
        action :enable
        only_if { ::File.directory?('/etc/elasticsearch') }
    end
end

action :stop do
    service "elasticsearch" do
        action :stop
        only_if { ::File.directory?('/etc/elasticsearch') }
    end
end