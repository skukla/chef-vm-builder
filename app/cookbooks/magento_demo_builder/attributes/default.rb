#
# Cookbook:: magento_demo_builder
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento_demo_builder][:chef_files][:path] = '/var/chef/cache/cookbooks/magento_demo_builder/files/default'
default[:magento_demo_builder][:demo_shell][:vendor] = 'CustomDemo'
default[:magento_demo_builder][:demo_shell][:files] = [
  { source: 'composer.json', path: '', mode: '664' },
  { source: 'registration.php', path: '', mode: '664' },
  { source: 'Install.php', path: 'Setup/Patch/Data', mode: '664' },
  { source: 'InstallStore.php', path: 'Setup/Patch/Data', mode: '644' },
  { source: 'module.xml', path: 'etc', mode: '664' }
]
default[:magento_demo_builder][:custom_modules] = {}
default[:magento_demo_builder][:data_packs] = {}
