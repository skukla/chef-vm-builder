#
# Cookbook:: samba
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "samba::external"
default[:samba][:use] = false
default[:samba][:share_list][:web_root] = node[:samba][:init][:web_root]
default[:samba][:share_list][:product_media_drop] = "#{node[:samba][:web_root]}/var/import/images"
default[:samba][:share_list][:content_media_drop] = "#{node[:samba][:web_root]}/pub/media/wysiwyg"
default[:samba][:share_fields] = [:path, :public, :browsable, :writeable, :force_user, :force_group, :comment]