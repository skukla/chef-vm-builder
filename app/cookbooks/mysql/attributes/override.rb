#
# Cookbook:: mysql
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = %i[socket port innodb_buffer_pool_size max_allowed_packet tmp_table_size max_heap_table_size db_host db_user db_password db_name]

supported_settings.each do |setting|
  if node[:infrastructure][:database].is_a? Chef::Node::ImmutableMash
    next if node[:infrastructure][:database][setting].nil?

    override[:mysql][setting] = node[:infrastructure][:database][setting]
  else
    next unless node[:infrastructure][:database].is_a? String

    override[:mysql][:db_name] = node[:infrastructure][:database] unless node[:infrastructure][:database].empty?
  end
end
