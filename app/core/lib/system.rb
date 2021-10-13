class System
	def System.cmd(command)
		`#{command}`
	end

	def System.sys_cmd(command)
		system(command)
	end

	def System.install_vagrant_plugins(plugin_list)
		sys_cmd("vagrant plugin install #{plugin_list.join(' ')}")
	end
end
