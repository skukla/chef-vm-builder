# Cookbook:: search_engine
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:type] = 'elasticsearch'
default[:search_engine][:elasticsearch][:java][:user] = 'root'
default[:search_engine][:elasticsearch][:java][:group] = 'root'
default[:search_engine][:elasticsearch][:user] = 'root'
default[:search_engine][:elasticsearch][:java][:package] = 'openjdk-11-jdk'
default[:search_engine][:elasticsearch][:java][:home] =
	"/usr/lib/jvm/java-11-openjdk-#{MachineHelper.arch}"
default[:search_engine][:elasticsearch][:java][:environment_file] =
	'/etc/environment'
default[:search_engine][:elasticsearch][:group] = 'elasticsearch'
default[:search_engine][:elasticsearch][:cluster_name] = 'Magento'
default[:search_engine][:elasticsearch][:service_file] =
	'/usr/lib/systemd/system/elasticsearch.service'
default[:search_engine][:elasticsearch][:debian_app_file] =
	'/etc/default/elasticsearch'
default[:search_engine][:elasticsearch][:app_config_file] =
	'/etc/elasticsearch/elasticsearch.yml'
default[:search_engine][:elasticsearch][:jvm_options_file] =
	'/etc/elasticsearch/jvm.options'
default[:search_engine][:elasticsearch][:log_file_path] =
	'/var/log/elasticsearch'
default[:search_engine][:elasticsearch][:node_name] = 'elasticsearch'
default[:search_engine][:elasticsearch][:version] = '7.x'
default[:search_engine][:elasticsearch][:host] = ElasticsearchHelper.host
default[:search_engine][:elasticsearch][:prefix] = DemoStructureHelper.base_url
default[:search_engine][:elasticsearch][:memory] = '2g'
default[:search_engine][:elasticsearch][:port] = '9200'
default[:search_engine][:elasticsearch][:plugin_list] = %w[
	analysis-phonetic
	analysis-icu
]
