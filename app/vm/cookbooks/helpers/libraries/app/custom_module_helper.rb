require_relative 'config_helper'

class CustomModuleHelper
	def CustomModuleHelper.list
		list = ConfigHelper.value('custom_demo/custom_modules')
		return [] if list.nil? || list.empty?

		list.map { |md| ModuleSharedHelper.prepare_data(md, 'custom module') }
	end
end
