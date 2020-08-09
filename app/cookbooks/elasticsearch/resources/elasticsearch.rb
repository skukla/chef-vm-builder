#
# Cookbook:: elasticsearch
# Resource:: elasticsearch 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :elasticsearch
provides :elasticsearch

property :name,             String,             name_property: true
property :user,             String,             default: node[:elasticsearch][:user]
property :group,            String,             default: node[:elasticsearch][:group]
property :java_home,        String,             default: node[:elasticsearch][:java][:java_home]
property :version,          String,             default: node[:elasticsearch][:version]
property :memory,           String,             default: node[:elasticsearch][:memory]
property :port,             [String, Integer],  default: node[:elasticsearch][:port]
property :cluster_name,     String,             default: node[:elasticsearch][:cluster_name]
property :node_name,        String,             default: node[:elasticsearch][:node_name]
property :log_file_path,    String,             default: node[:elasticsearch][:log_file_path]
property :jvm_options_file, String,             default: node[:elasticsearch][:jvm_options_file]
property :service_file,     String,             default: node[:elasticsearch][:service_file]
property :debian_app_file,  String,             default: node[:elasticsearch][:debian_app_file]
property :app_config_file,  String,             default: node[:elasticsearch][:app_config_file]
property :plugin_list,      Array,              default: node[:elasticsearch][:plugin_list]

action :uninstall do
    execute 'Purge Elasticsearch package and configuration' do
        command "dpkg --purge --force-all elasticsearch"
        only_if { ::File.directory?("/etc/elasticsearch") }
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
    
    apt_package "elasticsearch" do
        action :install
        ignore_failure true
        retries 3
        not_if { ::File.directory?("/etc/elasticsearch") }
    end
end

action :replace_service_file do
    template "elasticsearch.service file" do
        source "elasticsearch#{new_resource.version.split(".")[0]}.service.erb"
        path new_resource.service_file
        user new_resource.user
        group new_resource.group
        mode "644"
        variables({ java_home: new_resource.java_home })
        only_if { ::File.directory?("/etc/elasticsearch") }
    end
end

action :install_plugins do
    unless new_resource.plugin_list.empty?
        new_resource.plugin_list.each do |plugin|
            execute "Install #{plugin} elasticsearch plugin" do
                command "cd /usr/share/elasticsearch && bin/elasticsearch-plugin install #{plugin}"
                only_if { ::File.directory?("/etc/elasticsearch") }
            end
        end
    end
end

action :configure_jvm_options do
    template "JVM Options" do
        source "jvm.options.erb"
        path new_resource.jvm_options_file
        user new_resource.user
        group new_resource.group
        mode "644"
        variables({ memory: new_resource.memory })
        only_if { ::File.directory?("/etc/elasticsearch") }
    end
end

action :configure_app do
    template "Elasticsearch Configuration" do
        source "elasticsearch#{new_resource.version.split(".")[0]}.yml.erb"
        path new_resource.app_config_file
        user new_resource.user
        group new_resource.group
        mode "644"
        variables({ 
            port: new_resource.port,
            cluster_name: new_resource.cluster_name,
            node_name: new_resource.node_name,
            log_file_path: new_resource.log_file_path,
        })
        only_if { ::File.directory?("/etc/elasticsearch") }
    end

    template "Elasticsearch Configuration" do
        source "elasticsearch.debian.config.erb"
        path new_resource.debian_app_file
        user new_resource.user
        group new_resource.group
        mode "644"
        variables({ java_home: new_resource.java_home })
        only_if { ::File.directory?("/etc/elasticsearch") }
    end

    # Set ownership
    directory "/etc/elasticsearch" do
        owner new_resource.user
        group new_resource.group
        recursive true
    end
end

action :enable do
    service "elasticsearch" do
        action :enable
        only_if { ::File.directory?("/etc/elasticsearch") }
    end
end

action :restart do
    service "elasticsearch" do
        action :restart
        only_if { ::File.directory?("/etc/elasticsearch") }
    end
end

action :stop do
    service "elasticsearch" do
        action :stop
        only_if { ::File.directory?("/etc/elasticsearch") }
    end
end
