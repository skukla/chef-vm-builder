# Cookbook:: samba
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:samba][:init][:user] = node[:init][:os][:user]

include_attribute 'nginx::default'
default[:samba][:nginx][:web_root] = node[:nginx][:web_root]

default[:samba][:share_list][:web_root] = node[:samba][:nginx][:web_root]
default[:samba][:share_list][:product_media_share] = "#{node[:samba][:nginx][:web_root]}/var/import/images"
default[:samba][:share_list][:content_media_share] = "#{node[:samba][:nginx][:web_root]}/pub/media/wysiwyg"
default[:samba][:share_list][:backups_share] = "#{node[:samba][:nginx][:web_root]}/var/backups"
