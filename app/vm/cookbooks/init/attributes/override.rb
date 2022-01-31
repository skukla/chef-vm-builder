# Cookbook:: init
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings:
# vm: ip, name, hypervisor
# os: update, timezone
# custom_demo: structure{}
# frozen_string_literal: true

settings = [
	{ cfg_path: 'vm/hypervisor', cbk_path: 'vm/hypervisor' },
	{ cfg_path: 'infrastructure/os/update', cbk_path: 'os/update' },
	{ cfg_path: 'infrastructure/os/timezone', cbk_path: 'os/timezone' },
	{ cfg_path: 'custom_demo/structure', cbk_path: 'custom_demo/structure' },
]

override[:init][:vm][:ip] = MachineHelper.ip_address
settings.each do |setting|
	path = setting[:cbk_path].split('/')
	value = ConfigHelper.value(setting[:cfg_path])
	override[:init][path[0]][path[1]] = value unless value.nil?
end
