require_relative '../lib/config'
require_relative '../lib/service_dependencies'
require_relative '../lib/elasticsearch'

class ElasticsearchHandler
	@build_action = Config.value('application/build/action')

	def ElasticsearchHandler.install
		Elasticsearch.install if Elasticsearch.is_missing?
	end

	def ElasticsearchHandler.start
		unless Elasticsearch.is_running?
			Elasticsearch.start
			Elasticsearch.wait_until_available
		end
	end

	def ElasticsearchHandler.wipe
		if %w[install force_install restore].include?(@build_action)
			Elasticsearch.wipe
		end
	end
end
