# Cookbook:: magento_demo_builder
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento_demo_builder][:chef_files][:path] =
	'/var/chef/cache/cookbooks/magento_demo_builder/files/default'
default[:magento_demo_builder][:data_pack][:vendor] = 'custom-demo'
default[:magento_demo_builder][:data_pack][:files] = [
	{ source: 'composer.json', path: '', mode: '664' },
	{ source: 'registration.php', path: '', mode: '664' },
	{ source: 'module.xml', path: 'etc', mode: '664' },
]
