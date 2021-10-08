require_relative 'config'
class CustomModule
	def CustomModule.list
		Config.value('custom_demo/custom_modules')
	end

	def CustomModule.module_found?(module_arr)
		return false if list.nil? || list.empty?
		list.select { |custom_module| module_arr.include?(custom_module['source']) }
			.any?
	end

	def CustomModule.data_installer_found?
		return false if list.nil? || list.empty?
		https = 'https://github.com/PMET-public/module-data-install.git'
		ssh = 'github.com:PMET-public/module-data-install.git'

		CustomModule.module_found?(https) || CustomModule.module_found?(ssh)
	end
end
