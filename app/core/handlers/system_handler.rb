require_relative '../lib/system'

class SystemHandler
	def SystemHandler.clear_screen
		print System.cmd('clear')
	end

	def SystemHandler.remove_ds_store_files(path)
		System.cmd("find #{path} -name '.DS_Store' -type f -delete")
	end
end
