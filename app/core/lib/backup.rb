require_relative 'entry'

class Backup
	def Backup.files_found?
		backups = Entry.files_from('project/backup')
		return true if Entry.contains_zip?(backups)
		if (
				Entry.filename_contains?(backups, 'db') &&
					Entry.filename_contains?(backups, 'code') &&
					Entry.filename_contains?(backups, 'media')
		   )
			return true
		end
		false
	end
end
