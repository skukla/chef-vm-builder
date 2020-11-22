#
# Cookbook:: samba
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:samba][:use] = false
default[:samba][:share_fields] = %i[path public browseable writeable force_user force_group comment]

include_attribute 'samba::external'
default[:samba][:share_list][:web_root] = node[:samba][:init][:web_root]
default[:samba][:share_list][:product_media_share] = "#{node[:samba][:init][:web_root]}/var/import/images"
default[:samba][:share_list][:content_media_share] = "#{node[:samba][:init][:web_root]}/pub/media/wysiwyg"
default[:samba][:share_list][:backups_share] = "#{node[:samba][:init][:web_root]}/var/backups"
