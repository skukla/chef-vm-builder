require_relative 'config'

class CustomModule
	def CustomModule.list
		Config.setting('custom_demo/custom_modules')
	end

	def CustomModule.module_found?(module_arr)
		list
			.map { |_, pack| pack.is_a?(String) ? pack : pack['name'] }
			.reject(&:nil?)
			.select { |module_name| module_arr.include?(module_name) }
			.any?
	end

	def CustomModule.data_installer_found?
		module_found?(%w[magentoese/module-data-install])
	end
end
