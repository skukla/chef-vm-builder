#
# Cookbook:: init
# Resource:: init 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :init
provides :init

property :name,                 String,                  name_property: true
property :hostname,             String,                  default: node[:fqdn]
property :user,                 String,                  default: node[:init][:os][:user]
property :group,                String,                  default: node[:init][:os][:user]
property :ip,                   String,                  default: node[:init][:vm][:ip]
property :demo_structure,       Hash,                    default: node[:init][:custom_demo][:structure]
property :use_mailhog,          [TrueClass, FalseClass], default: node[:init][:use_mailhog]
property :use_webmin,           [TrueClass, FalseClass], default: node[:init][:use_webmin]

action :install_motd do
    execute "Remove MotDs" do
        command "chmod -x /etc/update-motd.d/*"
    end

    template "Custom MoTD" do
        source "custom_motd.erb"
        path "/etc/update-motd.d/01-custom"
        mode "755"
        owner "root"
        group "root"
        variables ({
            ip: "#{new_resource.ip}",
            hostname: "#{new_resource.hostname}",
            use_mailhog: "#{new_resource.use_mailhog}",
            use_webmin: "#{new_resource.use_webmin}",
            webmin_user: "#{new_resource.user}",
            webmin_password: "#{new_resource.user}",
            urls: DemoStructureHelper.get_vhost_urls(new_resource.demo_structure)
        })
    end
end