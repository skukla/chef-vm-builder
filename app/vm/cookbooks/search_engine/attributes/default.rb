# Cookbook:: search_engine
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:type] = 'elasticsearch'

include_attribute 'search_engine::default_java'
include_attribute 'search_engine::default_paths'
include_attribute 'search_engine::default_settings'
