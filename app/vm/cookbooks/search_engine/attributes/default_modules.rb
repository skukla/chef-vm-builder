# Cookbook:: search_engine
# Attribute:: default_modules
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:elasticsearch][:module_list] = %w[
  Magento_Elasticsearch
  Magento_Elasticsearch6
  Magento_Elasticsearch7
  Magento_ElasticsearchCatalogPermissions
  Magento_ElasticsearchCatalogPermissionsGraphQl
  Magento_InventoryElasticsearch
]
default[:search_engine][:open_search][:module_list] = %w[Magento_OpenSearch]

default[:search_engine][:live_search][:module_list] = %w[
  Magento_LiveSearch
  Magento_LiveSearchAdapter
  Magento_LiveSearchMetrics
  Magento_LiveSearchProductListing
  Magento_LiveSearchStorefrontPopover
  Magento_LiveSearchTerms
]
