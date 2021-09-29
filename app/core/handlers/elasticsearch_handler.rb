require_relative '../lib/config'
require_relative '../lib/service_dependencies'
require_relative '../lib/error_message'
require_relative '../lib/success_message'
require_relative '../lib/elasticsearch'
require_relative '../lib/demo_structure'
require_relative '../lib/string_replace'

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
			puts "Waiting for elasticsearch to become available... (Try #{num + 1} of 2)"
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

	def ElasticsearchHandler.wipe_all
		build_action = Config.value('application/build/action')
		if %w[install force_install restore].include?(build_action)
			unless Elasticsearch.is_running?
				abort(ErrorMsg.show(:elasticsearch_unavailable))
			end
			Elasticsearch.wipe
		end
	end

	def ElasticsearchHandler.wipe_index
		index = StringReplace.sanitize_base_url(DemoStructure.base_url)
		unless Elasticsearch.is_running?
			abort(ErrorMsg.show(:elasticsearch_unavailable))
		end
		Elasticsearch.wipe(index)
	end
end
