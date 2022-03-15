# Cookbook:: helpers
# Library:: app/elasticsearch_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ElasticsearchHelper
	def ElasticsearchHelper.host
		HypervisorHelper.elasticsearch_host
	end

	def ElasticsearchHelper.module_list
		%w[
			Magento_Elasticsearch
			Magento_Elasticsearch6
			Magento_Elasticsearch7
			Magento_ElasticsearchCatalogPermissions
			Magento_AdvancedSearch
			Magento_InventoryElasticsearch
		]
	end
end
