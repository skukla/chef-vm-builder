#
# Cookbook:: elasticsearch
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
version = node[:elasticsearch][:version]
plugins = node[:elasticsearch][:plugins]

# We have to use execute over chef resources here
execute "Add Elasticsearch #{version} repository" do
    command "sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - && echo \"deb https://artifacts.elastic.co/packages/#{version}/apt stable main\" | sudo tee -a /etc/apt/sources.list.d/elastic-#{version}.list && sudo apt-get update -y"
    not_if { ::File.directory?('/etc/elasticsearch') }
end

# Install Elasticsearch
apt_package 'elasticsearch' do
    action :install
    ignore_failure true
    retries 3
    not_if { ::File.directory?('/etc/elasticsearch') }
end

# Install Elasticsearch plugins
unless plugins.empty?
    plugins.each do |plugin|
        execute "Install #{plugin} elasticsearch plugin" do
            command "cd /usr/share/elasticsearch && bin/elasticsearch-plugin install #{plugin}"
            notifies :restart, "service[elasticsearch]", :immediately
            only_if { ::File.directory?('/etc/elasticsearch') }
        end
    end
end
