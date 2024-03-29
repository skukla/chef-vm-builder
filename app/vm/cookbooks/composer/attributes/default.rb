# Cookbook:: composer
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:composer][:file] = 'composer'
default[:composer][:install_dir] = '/usr/local/bin'
default[:composer][:version] = 'latest'
default[:composer][:timeout] = 2000
default[:composer][:clear_cache] = false
default[:composer][:plugins] = []
