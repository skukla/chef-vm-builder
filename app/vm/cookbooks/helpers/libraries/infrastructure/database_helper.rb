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
    conn_head = [conn_head, "--database=#{db}"].join(' ') unless db.nil?
    query_str = [conn_head, "\"#{query};\""].join(' -N -s -e ')

    SystemHelper.cmd(query_str)
  end

  def DatabaseHelper.get_config_value(path)
    DatabaseHelper.execute_query(
      "SELECT value FROM core_config_data WHERE path = '#{path}'",
      db_name,
    )
  end

  def DatabaseHelper.insert_config_value(cols_vals_arr)
    columns = cols_vals_arr.map { |item| `#{item[:column]}` }
    values = cols_vals_arr.map { |item| "'#{item[:value]}'" }

    execute_query(
      "INSERT INTO core_config_data (#{columns.join(', ')}) VALUES (#{values.join(', ')})",
      db_name,
    )
  end

  def DatabaseHelper.update_config_value(cols_vals_arr, path)
    columns =
      cols_vals_arr.map { |item| "`#{item[:column]}` = '#{item[:value]}'" }

    execute_query(
      "UPDATE core_config_data SET #{columns.join(', ')} WHERE path = '#{path}'",
      db_name,
    )
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
    SystemHelper.cmd("sudo su -; mysql -u root #{db_name} < #{db_dump}")
  end
end
