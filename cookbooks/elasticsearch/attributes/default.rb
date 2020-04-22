#
# Cookbook:: elasticsearch
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:infrastructure][:java][:java_home] = '/usr/lib/jvm/java-11-openjdk-amd64/'
default[:infrastructure][:elasticsearch][:user] = "elasticsearch"
default[:infrastructure][:elasticsearch][:group] = "elasticsearch"
default[:infrastructure][:elasticsearch][:cluster_name] = "Magento"
default[:infrastructure][:elasticsearch][:log_file_path] = "/var/log/elasticsearch"

# Prepare node name from VM name in config.json
["_", "-"].each do |token|
    if node[:vm][:name].include?(token)
        default[:infrastructure][:elasticsearch][:node_name] = node[:vm][:name].split(token).map(&:capitalize).join(" ")
    else
        default[:infrastructure][:elasticsearch][:node_name] = node[:vm][:name].split.map(&:capitalize).join(" ")
    end
end

# Prepare memory value from config.json
default[:infrastructure][:elasticsearch][:memory_value] = node[:infrastructure][:elasticsearch][:memory].downcase.split.join
