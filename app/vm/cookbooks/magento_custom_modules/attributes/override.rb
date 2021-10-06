# Cookbook:: magento_custom_modules
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = CustomModuleHelper.list

override[:magento_custom_modules][:module_list] = setting unless setting.nil?
