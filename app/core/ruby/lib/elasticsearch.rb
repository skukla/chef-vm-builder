require_relative 'system'
require_relative 'service_dependencies'
require_relative 'entry'

class Elasticsearch
	def Elasticsearch.is_missing?
		!Dir.exist?('/usr/local/var/homebrew/linked/elasticsearch-full')
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

	# def Elasticsearch.wait_until_available(secs)
	# 	puts 'Waiting for elasticsearch to start...'
	# 	secs.times do
	# 		print '.'
	# 		sleep 1
	# 	end
	# 	print "\n"
	# end

	def Elasticsearch.wait_until_available
		shell_lib_path = Entry.path('app/core/shell/lib')

		puts 'Waiting for Elasticsearch to become available...'
		Dir.chdir(shell_lib_path)
		System.cmd(
			'source ./functions.sh && wait_for_elasticsearch_to_become_available',
		)
	end

	def Elasticsearch.stop
		puts 'Stopping Elasticsearch...'
		System.cmd(
			'HOMEBREW_NO_AUTO_UPDATE=1 brew services stop elastic/tap/elasticsearch-full',
		)
	end

	def Elasticsearch.wipe
		System.cmd('curl -Ss -XDELETE localhost:9200/_all > /dev/null')
	end
end
