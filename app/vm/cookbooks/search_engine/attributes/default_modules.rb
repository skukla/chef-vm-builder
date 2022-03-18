# Cookbook:: search_engine
# Attribute:: default_modules
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:elasticsearch][:module_list] = %w[
	Magento_Elasticsearch
	Magento_Elasticsearch6
	Magento_Elasticsearch7
	Magento_ElasticsearchCatalogPermissions
	Magento_InventoryElasticsearch
]
default[:search_engine][:live_search][:module_list] = %w[
	Magento_LiveSearch
	Magento_LiveSearchAdapter
	Magento_LiveSearchMetrics
	Magento_LiveSearchStorefrontPopover
	Magento_LiveSearchTerms
]
