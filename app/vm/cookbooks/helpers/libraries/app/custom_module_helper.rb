require_relative 'config_helper'

class CustomModuleHelper
	def CustomModuleHelper.list
		ConfigHelper.value('custom_demo/custom_modules')
	end

	def CustomModuleHelper.module_found?(module_arr)
		list
			.reject(&:nil?)
			.select { |custom_module| module_arr.include?(custom_module['name']) }
			.any?
	end

	def CustomModuleHelper.data_installer_found?
		module_found?(%w[magentoese/module-data-install])
	end
end
