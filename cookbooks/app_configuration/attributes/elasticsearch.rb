default[:application][:installation][:elasticsearch_configuration] =
{
    catalog: {
        search: {
            enable_eav_indexer: 1,
            engine: "elasticsearch6",
            elasticsearch6_server_hostname: "127.0.0.1",
            elasticsearch6_server_port: node[:infrastructure][:elasticsearch][:port],
            elasticsearch6_index_prefix: "magento2",
            elasticsearch6_enable_auth: 0,
            elasticsearch6_server_timeout: 15
        }
    }
}
            