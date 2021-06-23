# Cookbook:: ssh
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:ssh][:private_keys][:file_path] = '/var/chef/cache/cookbooks/ssh/files/keys/private'
default[:ssh][:public_keys][:file_path] = '/var/chef/cache/cookbooks/ssh/files/keys/public'
