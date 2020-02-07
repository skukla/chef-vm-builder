#
# Cookbook:: init
# Recipe:: install_motd
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
ip = node[:vm][:ip]
hostname = node[:fqdn]
user = node[:vm][:user]
group = node[:vm][:group]

# Remove permissions on all present MotD files
execute 'Remove MotDs' do
    command "chmod -x /etc/update-motd.d/*"
end

# Install a custom MotD file
# ip is an environment attribute
# hostname comes from ohai
# webmin attributes are default cookbook attributes
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
        webmin_password: "#{group}"
    })
end
