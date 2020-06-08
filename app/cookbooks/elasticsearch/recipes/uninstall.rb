#
# Cookbook:: elasticsearch
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
service 'elasticsearch' do
    action :stop
end

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
execute "Manually remove the Elasticsearch sources file" do
    command "sudo rm -rf /etc/apt/sources.list.d/elastic*"
    only_if "ls /etc/apt/sources.list.d/elastic*"
end