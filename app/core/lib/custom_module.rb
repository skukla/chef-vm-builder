require_relative 'config'
class CustomModule
	def CustomModule.list
		Config.value('custom_demo/custom_modules')
	end

	def CustomModule.module_found?(module_arr)
		list
			.reject(&:nil?)
			.select { |custom_module| module_arr.include?(custom_module['name']) }
			.any?
	end

	def CustomModule.data_installer_found?
		module_found?(%w[magentoese/module-data-install])
	end
end
