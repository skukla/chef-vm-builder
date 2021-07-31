# Cookbook:: magento_demo_builder
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = DataPackHelper.list

unless setting.nil?
	list =
		setting.each_with_object([]) do |m, arr|
			arr << DataPackHelper.prepare_names(m)
		end
	override[:magento_demo_builder][:data_pack_list] = list
end
