# Cookbook:: helpers
# Library:: chef/database_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module DatabaseHelper
	def DatabaseHelper.execute_query(query)
		@db_user = Chef.node[:mysql][:db_user]
		@db_password = Chef.node[:mysql][:db_password]
		@db_name = Chef.node[:mysql][:db_name]

		connection_string =
			"mysql --user=#{@db_user} --password=#{@db_password} --database=#{@db_name}"
		query_string = "\"#{query};\""
		`#{[connection_string, query_string].join(' -N -s -e ')}`
	end

	def DatabaseHelper.check_code_exists(code)
		website_result =
			execute_query(
				"SELECT COUNT\(*\) FROM store_website WHERE code = '#{code}'",
			)
		store_view_result =
			execute_query("SELECT COUNT\(*\) FROM store WHERE code = '#{code}'")

		website_result.to_i.positive? || store_view_result.to_i.positive?
	end
end
