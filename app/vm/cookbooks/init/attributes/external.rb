# Cookbook:: init
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'php::default'
default[:init][:php][:version] = node[:php][:version]

include_attribute 'mailhog::default'
default[:init][:use_mailhog] = node[:mailhog][:use]

include_attribute 'search_engine::default'
default[:init][:search_engine][:type] = node[:search_engine][:type]
default[:init][:search_engine][:host] =
  node[:search_engine][:elasticsearch][:host]
default[:init][:search_engine][:port] =
  node[:search_engine][:elasticsearch][:port]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:init][:magento][:build_action] = node[:magento][:build][:action]

include_attribute 'magento_restore::default'
default[:init][:magento_restore][:holding_area] =
  node[:magento_restore][:holding_area]
