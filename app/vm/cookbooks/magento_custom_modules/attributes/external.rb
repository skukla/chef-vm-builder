# Cookbook:: magento_custom_modules
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'search_engine::default'
include_attribute 'search_engine::override'
default[:magento_custom_modules][:search_engine][:type] =
	node[:search_engine][:type]
