#
# Cookbook:: samba
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "samba::external"
default[:samba][:use] = false
default[:samba][:shares][:web_root] = node[:samba][:web_root]
default[:samba][:shares][:product_media_drop] = "#{node[:samba][:web_root]}/var/import/images"
default[:samba][:shares][:content_media_drop] = "#{node[:samba][:web_root]}/pub/media/wysiwyg"
default[:samba][:share_fields] = [:path, :public, :browsable, :writeable, :force_user, :force_group, :comment]