#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:application][:elasticsearch][:conf_options] = {
    enable_eav_indexer: {
        path: 'catalog/search/enable_eav_indexer',
        value: 1
    },
    search_engine: {
        path: 'catalog/search/engine',
        value: 'elasticsearch6'
    },
    elasticsearch6_server_hostname: {
        path: 'catalog/search/elasticsearch6_server_hostname',
        value: '127.0.0.1'
    },
    elasticsearch6_server_port: {
        path: 'catalog/search/elasticsearch6_server_port',
        value: node[:infrastructure][:elasticsearch][:port]
    },
    elasticsearch6_index_prefix: {
        path: 'catalog/search/elasticsearch6_index_prefix',
        value: 'magento2'
    },
    elasticsearch6_enable_auth: {
        path: 'catalog/search/elasticsearch6_enable_auth',
        value: 0
    },
    elasticsearch6_server_timeout: {
        path: 'catalog/search/elasticsearch6_server_timeout',
        value: 15
    }
}
