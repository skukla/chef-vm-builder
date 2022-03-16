# Cookbook:: search_engine
# Attribute:: elasticsearch_paths_default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

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
