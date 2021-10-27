# Cookbook:: helpers
# Library:: chef/database_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class DatabaseHelper
	def DatabaseHelper.db_name
		if Chef.node.override[:mysql][:db_name].empty?
			Chef.node.default[:mysql][:db_name]
		else
			Chef.node.override[:mysql][:db_name]
		end
	end

	def DatabaseHelper.execute_query(query, database_name = nil)
		conn_head = 'mysql --user=root'
		unless database_name.nil?
			conn_db = "--database=#{database_name}"
			conn_head = [conn_head, conn_db].join(' ')
		end
		SystemHelper.cmd([conn_head, "\"#{query};\""].join(' -N -s -e '))
	end

	def DatabaseHelper.db_exists?(db_name)
		StringReplaceHelper.replace_new_lines(
			execute_query("SHOW DATABASES LIKE '#{db_name}'"),
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
		default_db = Chef.node.default[:mysql][:db_name]
		override_db = Chef.node.override[:mysql][:db_name]

		if db_list.empty? || (override_db.empty? && db_list.include?(default_db))
			return []
		end

		db_list.reject { |db| db == override_db }
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

def DatabaseHelper.restore_dump(
	database_user,
	database_password,
	database_name,
	database_dump
)
	SystemHelper.cmd(
		"mysql -u #{database_user} -p#{database_password} #{database_name} < #{database_dump}",
	)
end
