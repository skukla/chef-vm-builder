#
# Cookbook:: demo_builder
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:demo_builder][:data_files][:directory] = "/var/chef/cache/cookbooks/demo_builder/files"
default[:demo_builder][:demo_shell][:directory] = "vendor/skukla/module-custom-demo-shell"
default[:demo_builder][:demo_shell][:fixtures_directory] = "fixtures"