require_relative 'config_helper'

class CustomModuleHelper
	def CustomModuleHelper.list
		ConfigHelper
			.value('custom_demo/custom_modules')
			.map { |md| ModuleSharedHelper.prepare_data(md, 'custom module') }
	end
end
