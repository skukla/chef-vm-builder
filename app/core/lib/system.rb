class System
	def System.cmd(command)
		`#{command}`
	end

	def System.sys_cmd(command)
		system(command)
	end
end
