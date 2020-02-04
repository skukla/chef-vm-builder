#
# Cookbook:: elasticsearch
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]
version = node[:infrastructure][:elasticsearch][:version]
user = node[:infrastructure][:elasticsearch][:user]
group = node[:infrastructure][:elasticsearch][:group]
java_home = node[:infrastructure][:java][:java_home]
memory = node[:infrastructure][:elasticsearch][:memory]
cluster_name = node[:infrastructure][:elasticsearch][:conf_options][:cluster_name]
node_name = node[:infrastructure][:elasticsearch][:conf_options][:node_name]
log_file_path = node[:infrastructure][:elasticsearch][:conf_options][:log_file_path]
port = node[:infrastructure][:elasticsearch][:port]
plugins = node[:infrastructure][:elasticsearch][:plugins]

if use_elasticsearch    
    # Configure Java Options
    template 'JVM Options' do
        source 'jvm.options.erb'
        path '/etc/elasticsearch/jvm.options'
        user "#{user}"
        group "#{group}"
        mode '644'
        variables({ memory: memory })
    end

    # Configure Elasticsearch
    template 'Elasticsearch Configuration ' do
        source 'elasticsearch.yml.erb'
        path '/etc/elasticsearch/elasticsearch.yml'
        user "#{user}"
        group "#{group}"
        mode '644'
        variables({ 
            cluster_name: cluster_name,
            node_name: node_name,
            log_file_path: log_file_path,
            port: port
        })
    end

    # Set Java Home for Elasticsearch
    ruby_block 'Set JAVA_HOME in /etc/environment' do
        block do
            file = Chef::Util::FileEdit.new('/etc/environment')
            file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
            file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
            file.write_file
        end
        only_if { ::File.exists?('/etc/environment') }
    end

    ruby_block "Set JAVA_HOME for Elasticsearch #{version}" do
        block do
            file = Chef::Util::FileEdit.new('/etc/default/elasticsearch')
            file.insert_line_if_no_match(/^#JAVA_HOME=/, "JAVA_HOME=#{java_home}")
            file.search_file_replace_line(/^#JAVA_HOME=/, "JAVA_HOME=#{java_home}")
            file.write_file
        end
        only_if { ::File.exists?('/etc/default/elasticsearch') }
    end

    # Set ownership to Elasticsearch user and group
    directory '/etc/elasticsearch' do
        owner "#{user}"
        group "#{group}"
        recursive true
    end
    
    # Define, enable, and start the Elasticsearch service
    service 'elasticsearch' do
        action [:start, :enable]
        only_if { ::File.directory?('/etc/elasticsearch') }
    end

    # Uninstall/(Re-)Install Elasticsearch plugins
    unless plugins.empty?
        plugins.each do |plugin|
            execute "Remove #{plugin} elasticsearch plugin" do
                command "cd /usr/share/elasticsearch && bin/elasticsearch-plugin remove #{plugin}"
                only_if { ::File.directory?("/usr/share/elasticsearch/plugins/#{plugin}") }
            end
            
            execute "Install #{plugin} elasticsearch plugin" do
                command "cd /usr/share/elasticsearch && bin/elasticsearch-plugin install #{plugin}"
                notifies :restart, "service[elasticsearch]", :delayed
                only_if { ::File.directory?('/etc/elasticsearch') }
            end
        end
    end
end
