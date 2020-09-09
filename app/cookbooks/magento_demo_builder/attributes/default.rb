#
# Cookbook:: magento_demo_builder
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento_demo_builder][:data_files][:directory] = "/var/chef/cache/cookbooks/magento_demo_builder/files/data"
default[:magento_demo_builder][:media_files][:content_directory] = "/var/chef/cache/cookbooks/magento_demo_builder/files/media/content"
default[:magento_demo_builder][:media_files][:products_directory] = "/var/chef/cache/cookbooks/magento_demo_builder/files/media/products"
default[:magento_demo_builder][:patches][:directory] = "/var/chef/cache/cookbooks/magento_demo_builder/files/patches"
default[:magento_demo_builder][:demo_shell][:patch_class] = %q[Skukla\CustomDemoShell\Setup\Patch\Data]
default[:magento_demo_builder][:demo_shell][:directory] = "vendor/skukla/module-custom-demo-shell"
default[:magento_demo_builder][:demo_shell][:fixtures_directory] = "fixtures"