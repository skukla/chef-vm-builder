# Cookbook:: helpers
# Library:: chef/database_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class DatabaseHelper
	def DatabaseHelper.db_user
		Chef.node.default[:mysql][:db_user]
	end

	def DatabaseHelper.db_password
		Chef.node.default[:mysql][:db_password]
	end

	def DatabaseHelper.db_name
		Chef.node.default[:mysql][:db_name]
	end

	def DatabaseHelper.execute_query(query, db = nil)
		conn_head = 'mysql --user=root'
		conn_head = [conn_head, "--database=#{db_name}"].join(' ') unless db.nil?
		SystemHelper.cmd([conn_head, "\"#{query};\""].join(' -N -s -e '))
	end

	def DatabaseHelper.db_exists?(db)
		StringReplaceHelper.replace_new_lines(
			execute_query("SHOW DATABASES LIKE '#{db}'"),
		).any?
	end

	def DatabaseHelper.db_list
		databases =
			StringReplaceHelper.replace_new_lines(execute_query('SHOW DATABASES'))
		return [] if databases.nil?

		databases.reject do |db|
			%w[information_schema performance_schema mysql].include?(db)
		end
	end

	def DatabaseHelper.extra_db_list
		override_db = Chef.node.override[:mysql][:db_name]
		system_dbs = %w[sys]

		if db_list.empty? || (override_db.empty? && db_list.include?(db_name))
			return []
		end

		db_list.reject { |db| (db == override_db) || system_dbs.include?(db) }
	end
end

def DatabaseHelper.code_exists?(code)
	website_result =
		execute_query(
			"SELECT COUNT\(*\) FROM store_website WHERE code = '#{code}'",
			db_name,
		)
	store_view_result =
		execute_query(
			"SELECT COUNT\(*\) FROM store WHERE code = '#{code}'",
			db_name,
		)
	website_result.to_i.positive? || store_view_result.to_i.positive?
end

def DatabaseHelper.restore_dump(db_dump)
	SystemHelper.cmd(
		"mysql -u #{db_user} -p#{db_password} #{db_name} < #{db_dump}",
	)
end
