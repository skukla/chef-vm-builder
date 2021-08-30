# Cookbook:: samba
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:samba][:share_fields] = %i[
	path
	public
	browseable
	writeable
	force_user
	force_group
	comment
]
default[:samba][:configuration_directory] = '/etc/samba'
default[:samba][:service_file] = '/lib/systemd/system/smbd.service'
