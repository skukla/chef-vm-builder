# Cookbook:: search_engine
# Attribute:: elasticsearch_settings_default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:elasticsearch][:user] = 'root'
default[:search_engine][:elasticsearch][:group] = 'elasticsearch'
default[:search_engine][:elasticsearch][:cluster_name] = 'Magento'
default[:search_engine][:elasticsearch][:node_name] = 'elasticsearch'
default[:search_engine][:elasticsearch][:version] = '7.x'
default[:search_engine][:elasticsearch][:host] = ElasticsearchHelper.host
default[:search_engine][:elasticsearch][:prefix] = DemoStructureHelper.base_url
default[:search_engine][:elasticsearch][:memory] = '2g'
default[:search_engine][:elasticsearch][:port] = '9200'
default[:search_engine][:elasticsearch][:plugin_list] = %w[
	analysis-phonetic
	analysis-icu
]
default[:search_engine][:elasticsearch][:module_list] = %w[
	Magento_Elasticsearch
	Magento_Elasticsearch6
	Magento_Elasticsearch7
	Magento_ElasticsearchCatalogPermissions
	Magento_InventoryElasticsearch
]
