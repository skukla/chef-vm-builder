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
custom_demo_data = node[:custom_demo][:verticals]

# Remove permissions on all present MotD files
execute 'Remove MotDs' do
    command "chmod -x /etc/update-motd.d/*"
end

# Extract the urls for the custom motd
selected_vertical_urls = Array.new
custom_demo_data.each do |vertical_key, vertical_value|
    vertical_value.each do |channel_key, channel_value|
        next unless vertical_value[channel_key][:use]
        selected_vertical_urls << vertical_value[channel_key][:url]
    end
end

# Install a custom MotD file
# ip is an environment attribute, hostname comes from ohai, webmin attributes are default cookbook attributes
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
        urls: selected_vertical_urls
    })
end
