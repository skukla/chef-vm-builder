# Cookbook:: magento_modules
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'magento::default'
default[:magento_modules][:magento][:build][:add_required_modules] =
  node[:magento][:build][:add_required_modules]
