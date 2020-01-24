#
# Cookbook:: init
# Recipe:: install_motd
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Remove permissions on all present MotD files
execute 'Remove MotDs' do
    command "chmod -x /etc/update-motd.d/*"
end

# Install a custom MotD file
# ip is an environment attribute
# hostname comes from ohai
# webmin attributes are default cookbook attributes
template 'Custom MoTD' do
    path '/etc/update-motd.d/01-custom'
    source 'custom_motd.erb'
    mode 755
    owner 'root'
    group 'root'
    variables ({
        ip: "#{node[:vm][:ip]}",
        hostname: "#{node[:fqdn]}",
        webmin_user: "#{node[:vm][:user]}",
        webmin_password: "#{node[:vm][:group]}"
    })
end
