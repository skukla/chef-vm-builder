# Cookbook:: samba
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:samba][:share_list][:web_root] = node[:samba][:nginx][:web_root]
default[:samba][:share_list][:product_media_share] =
	"#{node[:samba][:nginx][:web_root]}/var/import/images"
default[:samba][:share_list][:content_media_share] =
	"#{node[:samba][:nginx][:web_root]}/pub/media/wysiwyg"
default[:samba][:share_list][:backups_share] =
	"#{node[:samba][:nginx][:web_root]}/var/backups"
