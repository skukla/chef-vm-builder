# Cookbook:: helpers
# Library:: app/elasticsearch_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ElasticsearchHelper
	def ElasticsearchHelper.host
		HypervisorHelper.elasticsearch_host
	end
end
