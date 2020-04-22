#
# Cookbook:: init
# Recipe:: install_motd
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]
ip = node[:vm][:ip]
hostname = node[:fqdn]
custom_demo_structure = node[:custom_demo][:structure]

# Remove permissions on all present MotD files
execute 'Remove MotDs' do
    command "chmod -x /etc/update-motd.d/*"
end

# Extract the urls for the custom motd
demo_urls = Array.new
custom_demo_structure.each do |scope, scope_hash|
    scope_hash.each do |code, url|
        demo_urls << url
    end
end

# Install a custom MotD file
template 'Custom MoTD' do
    source 'custom_motd.erb'
    path '/etc/update-motd.d/01-custom'
    mode '755'
    owner 'root'
    group 'root'
    variables ({
        ip: "#{ip}",
        hostname: "#{hostname}",
        webmin_user: "#{user}",
        webmin_password: "#{group}",
        urls: demo_urls
    })
end
