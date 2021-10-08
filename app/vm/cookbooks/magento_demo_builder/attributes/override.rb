# Cookbook:: magento_demo_builder
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

override[:magento_demo_builder][:data_pack_list] = DataPackHelper.list
override[:magento_demo_builder][:remote_data_pack_list] =
	DataPackHelper.remote_list
