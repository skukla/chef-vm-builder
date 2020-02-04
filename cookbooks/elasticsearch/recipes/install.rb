#
# Cookbook:: elasticsearch
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]
user = node[:infrastructure][:elasticsearch][:user]
group = node[:infrastructure][:elasticsearch][:group]
version = node[:infrastructure][:elasticsearch][:version]

# Always remove Elasticsearch
execute 'Purge Elasticsearch package and configuration' do
    command "sudo dpkg --purge --force-all elasticsearch"
end
    
# Manually remove Elasticsearch folders if they exist
['/var/lib/elasticsearch', '/etc/elasticsearch'].each do |folder|
    execute "Manually remove Elasticsearch #{folder}" do
        command "sudo rm -rf #{folder}"
        only_if { ::File.directory?("#{folder}") }
    end
end

# Manually remove the sources list file
execute "Manually remove the Elasticsearch #{version} sources file" do
    command "sudo rm -rf /etc/apt/sources.list.d/elastic-*"
    only_if "ls /etc/apt/sources.list.d/elastic-*"
end

# Check to see if we want to use Elasticsearch and then install
if use_elasticsearch
    # Add the Elasticsearch repository key (We have to use execute over chef resources here)
    execute "Add Elasticsearch #{version} repository" do
        command "sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - && echo \"deb https://artifacts.elastic.co/packages/#{version}/apt stable main\" | sudo tee -a /etc/apt/sources.list.d/elastic-#{version}.list && sudo apt-get update -y"
        not_if { ::File.directory?('/etc/elasticsearch') }
    end

    # Install Elasticsearch
    apt_package 'elasticsearch' do
        action :install
        ignore_failure true
        not_if { ::File.directory?('/etc/elasticsearch') }
    end
end
