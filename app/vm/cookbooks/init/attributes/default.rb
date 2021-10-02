# Cookbook:: init
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:init][:os][:user] = 'vagrant'
default[:init][:os][:update] = false
default[:init][:os][:timezone] = 'America/Los_Angeles'
default[:init][:os][:install_package_list] = %w[
	zip
	silversearcher-ag
	figlet
	unattended-upgrades
	zlibc
	tree
	jq
]
