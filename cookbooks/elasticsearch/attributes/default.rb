#
# Cookbook:: elasticsearch
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:infrastructure][:java][:java_home] = '/usr/lib/jvm/java-11-openjdk-amd64/'
default[:infrastructure][:elasticsearch] = {
    user: 'elasticsearch',
    group: 'elasticsearch'
}
default[:infrastructure][:elasticsearch][:conf_options] = {
    es_port: node[:infrastructure][:elasticsearch][:port],
    cluster_name: 'Magento',
    node_name: 'Luma',
    log_file_path: '/var/log/elasticsearch',
    plugins: node[:infrastructure][:elasticsearch][:plugins]
}
