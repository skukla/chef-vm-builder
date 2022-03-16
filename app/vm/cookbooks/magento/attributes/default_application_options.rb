# Cookbook:: magento
# Attribute:: default_application_options
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento][:options][:family] = MagentoHelper.define_family('Commerce')
default[:magento][:options][:minimum_stability] = 'stable'
