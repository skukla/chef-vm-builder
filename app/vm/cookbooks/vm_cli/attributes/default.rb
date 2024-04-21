# Cookbook:: vm_cli
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:vm_cli][:directory] = { path: 'cli', mode: '770' }
default[:vm_cli][:files] = [
  { source: '.bashrc', mode: '644' },
  { source: 'help.sh', mode: '755' },
]
default[:vm_cli][:backup_dir] = 'var/backups'
default[:vm_cli][:config_json_dir] =
  '/var/chef/cache/cookbooks/helpers/libraries'
