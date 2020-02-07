#
# Cookbook:: samba
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in init attributes
include_attribute 'init::default'
include_attribute 'nginx::default'

default[:infrastructure][:samba][:user] = node[:vm][:user]
default[:infrastructure][:samba][:group] = node[:vm][:group]

default[:infrastructure][:samba][:share_settings][:composer_credentials] = {
    title: 'Composer Credentials',
    comment: 'Composer credentials',
    path: "/home/#{node[:vm][:user]}/.composer",
    writable: 'yes',
    browsable: 'yes',
    read_only: 'no',
    guest_ok: 'yes',
    public: 'yes'
}
default[:infrastructure][:samba][:share_settings][:web_root] = {
    title: 'Web Root',
    comment: 'Magento codebase',
    path: "#{node[:infrastructure][:webserver][:conf_options][:web_root]}",
    writable: 'yes',
    browsable: 'yes',
    read_only: 'no',
    guest_ok: 'yes',
    public: 'yes'
}
default[:infrastructure][:samba][:share_settings][:image_drop] = {
    title: 'Image Drop',
    comment: 'Image import directory on the VM',
    path: "#{node[:infrastructure][:webserver][:conf_options][:web_root]}/pub/media/import",
    writable: 'yes',
    browsable: 'yes',
    read_only: 'no',
    guest_ok: 'yes',
    public: 'yes'
}
default[:infrastructure][:samba][:share_settings][:application_modules] = {
    title: 'Application Modules',
    comment: 'Extensions directory on the VM',
    path: "#{node[:infrastructure][:webserver][:conf_options][:web_root]}/vendor",
    writable: 'yes',
    browsable: 'yes',
    read_only: 'no',
    guest_ok: 'yes',
    public: 'yes'
}
default[:infrastructure][:samba][:share_settings][:multisite_configuration] = {
    title: 'Multisite Configuration',
    comment: 'Multisite configurations on the VM',
    path: "/etc/nginx/sites-available",
    writable: 'yes',
    browsable: 'yes',
    read_only: 'no',
    guest_ok: 'yes',
    public: 'yes'
}
default[:infrastructure][:samba][:share_settings][:application_design] = {
    title: 'App-Design',
    comment: 'App/Design directory for themes on the VM',
    path: "#{node[:infrastructure][:webserver][:conf_options][:web_root]}/app/design",
    writable: 'yes',
    browsable: 'yes',
    read_only: 'no',
    guest_ok: 'yes',
    public: 'yes'
}
