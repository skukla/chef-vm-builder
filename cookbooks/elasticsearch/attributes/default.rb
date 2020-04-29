#
# Cookbook:: elasticsearch
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:elasticsearch][:java_home] = '/usr/lib/jvm/java-11-openjdk-amd64/'
default[:elasticsearch][:user] = "elasticsearch"
default[:elasticsearch][:group] = "elasticsearch"
default[:elasticsearch][:cluster_name] = "Magento"
default[:elasticsearch][:log_file_path] = "/var/log/elasticsearch"

# Prepare node name from VM name in config.json
["_", "-"].each do |token|
    if node[:vm][:name].include?(token)
        default[:elasticsearch][:node_name] = node[:vm][:name].split(token).map(&:capitalize).join(" ")
    else
        default[:elasticsearch][:node_name] = node[:vm][:name].split.map(&:capitalize).join(" ")
    end
end

default[:elasticsearch][:use] = true
default[:elasticsearch][:version] = "6.x"
default[:elasticsearch][:memory] = "1g"
default[:elasticsearch][:port] = 9200
default[:elasticsearch][:plugins] = ["analysis-phonetic", "analysis-icu"]