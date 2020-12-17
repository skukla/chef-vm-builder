#
# Cookbook:: helpers
# Library:: database_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module DatabaseHelper
  def self.execute_query(db_user, db_password, db_name, query)
    connection_string = "mysql --user=#{db_user} --password=#{db_password} --database=#{db_name}"
    query_string = "\"#{query};\""
    `#{[connection_string, query_string].join(' -N -s -e ')}`
  end

  def self.patch_exists(patch_class, db_user, db_password, db_name)
    connection_string = "mysql --user=#{db_user} --password=#{db_password} --database=#{db_name}"
    query_string = "\"SELECT * FROM patch_list WHERE patch_name = '#{patch_class}';\""
    select_result = `#{[connection_string, query_string].join(' -e ')}`
    !select_result.empty?
  end

  def self.remove_data_patch(patch_class, db_user, db_password, db_name)
    connection_string = "mysql --user=#{db_user} --password=#{db_password} --database=#{db_name}"
    query_string = "\"DELETE FROM patch_list WHERE patch_name = '#{patch_class}';\""
    `#{[connection_string, query_string].join(' -e ')}`
    print "Ran #{query_string}"
  end

  def self.check_code_exists(db_user, db_password, db_name, code)
    website_result = execute_query(db_user, db_password, db_name, "SELECT COUNT\(*\) FROM store_website WHERE code = '#{code}'")
    store_view_result = execute_query(db_user, db_password, db_name, "SELECT COUNT\(*\) FROM store WHERE code = '#{code}'")
    if website_result.to_i.positive? || store_view_result.to_i.positive?
      true
    else
      false
    end
  end
end
