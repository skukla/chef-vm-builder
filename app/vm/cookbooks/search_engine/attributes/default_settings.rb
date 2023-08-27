# Cookbook:: search_engine
# Attribute:: default_settings
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:elasticsearch][:user] = 'root'
default[:search_engine][:elasticsearch][:group] = 'elasticsearch'
default[:search_engine][:elasticsearch][:cluster_name] = 'Magento'
default[:search_engine][:elasticsearch][:node_name] = 'elasticsearch'
default[:search_engine][:elasticsearch][:version] = '7.x'
default[:search_engine][:elasticsearch][:memory] = '2g'
default[:search_engine][:elasticsearch][:setting_config_path] =
  'catalog/search/engine'
default[:search_engine][:elasticsearch][:setting] = 'elasticsearch7'
default[:search_engine][:elasticsearch][:host_config_path] =
  'catalog/search/elasticsearch7_server_hostname'
default[:search_engine][:elasticsearch][:host] = ElasticsearchHelper.host
default[:search_engine][:elasticsearch][:port_config_path] =
  'catalog/search/elasticsearch7_server_port'
default[:search_engine][:elasticsearch][:port] = '9200'
default[:search_engine][:elasticsearch][:prefix_config_path] =
  'catalog/search/elasticsearch7_index_prefix'
default[:search_engine][:elasticsearch][:prefix] = DemoStructureHelper.base_url
default[:search_engine][:elasticsearch][:plugin_list] = %w[
  analysis-phonetic
  analysis-icu
]
