#
# Cookbook:: helpers
# Library:: database_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module DatabaseHelper
  def self.execute_query(query)
    @db_user = if Chef.node.override['mysql']['db_user'].nil? ||
                  Chef.node.override['mysql']['db_user'].empty?
                 Chef.node.default['mysql']['db_user']
               else
                 Chef.node.override['mysql']['db_user']
               end

    @db_password = if Chef.node.override['mysql']['db_password'].nil? ||
                      Chef.node.override['mysql']['db_password'].empty?
                     Chef.node.default['mysql']['db_password']
                   else
                     Chef.node.override['mysql']['db_password']
                   end

    @db_name = if Chef.node.override['mysql']['db_name'].nil? ||
                  Chef.node.override['mysql']['db_name'].empty?
                 Chef.node.default['mysql']['db_name']
               else
                 Chef.node.override['mysql']['db_name']
               end

    connection_string = "mysql --user=#{@db_user} --password=#{@db_password} --database=#{@db_name}"
    query_string = "\"#{query};\""
    `#{[connection_string, query_string].join(' -N -s -e ')}`
  end

  def self.remove_data_patch(module_name)
    execute_query("DELETE from patch_list WHERE patch_name LIKE '%#{module_name}%'")
  end

  def self.check_code_exists(code)
    website_result = execute_query("SELECT COUNT\(*\) FROM store_website WHERE code = '#{code}'")
    store_view_result = execute_query("SELECT COUNT\(*\) FROM store WHERE code = '#{code}'")

    website_result.to_i.positive? || store_view_result.to_i.positive?
  end
end
