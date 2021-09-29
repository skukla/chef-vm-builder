require_relative 'system'
require_relative 'service_dependencies'
require_relative 'entry'

class Elasticsearch
	def Elasticsearch.is_missing?
		!Dir.exist?('/usr/local/var/lib/elasticsearch')
	end

	def Elasticsearch.is_running?
		System.cmd('curl --stderr - localhost:9200 | grep -q cluster_name;')
		$?.exitstatus == 0
	end

	def Elasticsearch.install
		puts 'Adding the Elasticsearch repository...'
		System.cmd('HOMEBREW_NO_AUTO_UPDATE=1 brew tap elastic/tap')

		puts 'Installing the Elasticsearch application...'
		System.cmd(
			'HOMEBREW_NO_AUTO_UPDATE=1 brew install elastic/tap/elasticsearch-full',
		)
	end

	def Elasticsearch.start
		puts 'Starting Elasticsearch as a service...'
		System.cmd(
			'HOMEBREW_NO_AUTO_UPDATE=1 brew services start elastic/tap/elasticsearch-full',
		)
	end

	def Elasticsearch.wait_until_available(secs)
		secs.times do
			print '.'
			sleep 1
		end
		print "\n"
	end

	def Elasticsearch.stop
		puts 'Stopping Elasticsearch...'
		System.cmd(
			'HOMEBREW_NO_AUTO_UPDATE=1 brew services stop elastic/tap/elasticsearch-full',
		)
	end

	def Elasticsearch.wipe(index = nil)
		if index.nil?
			return System.cmd('curl -Ss -XDELETE localhost:9200/_all > /dev/null')
		end
		System.cmd("curl -Ss -XDELETE \"localhost:9200/#{index}*\" > /dev/null")
	end
end
