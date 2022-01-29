require_relative '../lib/config'
require_relative '../lib/service_dependencies'
require_relative '../lib/error_message'
require_relative '../lib/success_message'
require_relative '../lib/elasticsearch'
require_relative '../lib/demo_structure'

class ElasticsearchHandler
	def ElasticsearchHandler.install
		Elasticsearch.install if Elasticsearch.is_missing?
	end

	def ElasticsearchHandler.is_available?
		wait_time = @search_setting['wait_time'] if @search_setting.is_a?(Hash)

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

	def ElasticsearchHandler.wipe(index = nil)

		unless Elasticsearch.is_running?
			abort(ErrorMsg.show(:elasticsearch_unavailable))
		end

		if index.nil? && %w[install force_install restore].include?(Config.build_action)
			Elasticsearch.wipe
		end

		Elasticsearch.wipe(index) unless index.nil?
	end
end
