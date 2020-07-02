#
# Cookbook:: elasticsearch
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:elasticsearch][:java][:java_home] = '/usr/lib/jvm/java-11-openjdk-amd64/'
default[:elasticsearch][:java][:environment_file] = "/etc/environment"
default[:elasticsearch][:user] = "elasticsearch"
default[:elasticsearch][:cluster_name] = "Magento"
default[:elasticsearch][:app_file] = "/etc/default/elasticsearch"
default[:elasticsearch][:log_file_path] = "/var/log/elasticsearch"
default[:elasticsearch][:node_name] = "elasticsearch"
default[:elasticsearch][:use] = true
default[:elasticsearch][:version] = "6.x"
default[:elasticsearch][:memory] = "1g"
default[:elasticsearch][:host] = "127.0.0.1"
default[:elasticsearch][:port] = 9200
default[:elasticsearch][:plugin_list] = ["analysis-phonetic", "analysis-icu"]