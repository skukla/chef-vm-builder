require_relative '../lib/config'
require_relative '../lib/service_dependencies'
require_relative '../lib/error_message'
require_relative '../lib/success_message'
require_relative '../lib/elasticsearch'

class ElasticsearchHandler
	def ElasticsearchHandler.install
		Elasticsearch.install if Elasticsearch.is_missing?
	end

	def ElasticsearchHandler.is_available?
		if Config.value('infrastructure/elasticsearch').is_a?(Hash)
			wait_time = Config.value('infrastructure/elasticsearch/wait_time')
		end

		wait_time = 30 if wait_time.to_s.empty?
		result = false
		num = 0
		while num <= 1
			puts "Waiting for elasticsearch to start...(Try #{num + 1} of 2)"
			result = Elasticsearch.is_running?
			Elasticsearch.wait_until_available(wait_time) unless result
			num += 1
		end
		result
	end

	def ElasticsearchHandler.start
		unless Elasticsearch.is_running?
			Elasticsearch.start
			unless ElasticsearchHandler.is_available?
				abort(ErrorMsg.show(:elasticsearch_unavailable))
			end
			print SuccessMsg.show(:elasticsearch_available)
		end
	end

	def ElasticsearchHandler.wipe
		build_action = Config.value('application/build/action')
		if %w[install force_install restore].include?(build_action)
			unless Elasticsearch.is_running?
				abort(ErrorMsg.show(:elasticsearch_unavailable))
			end
			Elasticsearch.wipe
		end
	end
end
