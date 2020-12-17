#
# Cookbook:: helpers
# Library:: database_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module DatabaseHelper
  def self.execute_query(query)
    @db_user = Chef.node.default['mysql']['db_user']
    @db_password = Chef.node.default['mysql']['db_password']
    @db_name = Chef.node.default['mysql']['db_name']

    connection_string = "mysql --user=#{@db_user} --password=#{@db_password} --database=#{@db_name}"
    query_string = "\"#{query};\""
    `#{[connection_string, query_string].join(' -N -s -e ')}`
  end

  def self.patch_exists(patch_class)
    result = execute_query("SELECT * FROM patch_list WHERE patch_name = '#{patch_class}'")
    !result.empty?
  end

  def self.remove_data_patch(patch_class)
    query_string = "DELETE FROM patch_list WHERE patch_name = '#{patch_class}'"
    execute_query(query_string)
    print "Ran #{query_string}"
  end

  def self.check_code_exists(code)
    website_result = execute_query("SELECT COUNT\(*\) FROM store_website WHERE code = '#{code}'")
    store_view_result = execute_query("SELECT COUNT\(*\) FROM store WHERE code = '#{code}'")

    website_result.to_i.positive? || store_view_result.to_i.positive? ? true : false
  end
end
