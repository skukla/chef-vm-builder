#
# Cookbook:: elasticsearch
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:elasticsearch][:java][:user] = 'root'
default[:elasticsearch][:java][:group] = 'root'
default[:elasticsearch][:java][:package] = 'openjdk-11-jdk'
default[:elasticsearch][:java][:home] = '/usr/lib/jvm/java-11-openjdk-amd64'
default[:elasticsearch][:java][:environment_file] = '/etc/environment'
default[:elasticsearch][:user] = 'root'
default[:elasticsearch][:group] = 'elasticsearch'
default[:elasticsearch][:cluster_name] = 'Magento'
default[:elasticsearch][:service_file] = '/usr/lib/systemd/system/elasticsearch.service'
default[:elasticsearch][:debian_app_file] = '/etc/default/elasticsearch'
default[:elasticsearch][:app_config_file] = '/etc/elasticsearch/elasticsearch.yml'
default[:elasticsearch][:jvm_options_file] = '/etc/elasticsearch/jvm.options'
default[:elasticsearch][:log_file_path] = '/var/log/elasticsearch'
default[:elasticsearch][:node_name] = 'elasticsearch'
default[:elasticsearch][:use] = true
default[:elasticsearch][:version] = '7.x'
default[:elasticsearch][:host] = '127.0.0.1'
default[:elasticsearch][:memory] = '2g'
default[:elasticsearch][:port] = 9200
default[:elasticsearch][:plugin_list] = %w[analysis-phonetic analysis-icu]
