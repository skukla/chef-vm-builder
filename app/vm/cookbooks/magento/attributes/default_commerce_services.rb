# Cookbook:: magento
# Attribute:: default_commerce_services
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento][:csc_options][:key_path] =
	'/var/chef/cache/cookbooks/magento/files/default'
default[:magento][:csc_options][:production_api_key] = ''
default[:magento][:csc_options][:project_id] = ''
default[:magento][:csc_options][:environment_id] = ''
