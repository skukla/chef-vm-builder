#
# Cookbook:: elasticsearch
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:use, :host, :version, :memory, :port, :plugins]

supported_settings.each do |setting|
    if node[:infrastructure][:elasticsearch].is_a? Chef::Node::ImmutableMash
        next if node[:infrastructure][:elasticsearch][setting].nil?
        if setting == :memory
            override[:elasticsearch][setting] = node[:infrastructure][:elasticsearch][:memory].downcase
        else
            override[:elasticsearch][setting] = node[:infrastructure][:elasticsearch][setting]
        end
    else
        next unless (node[:infrastructure][:elasticsearch].is_a? TrueClass) || (node[:infrastructure][:elasticsearch].is_a? FalseClass)
        override[:elasticsearch][:use] = node[:infrastructure][:elasticsearch]
    end
end
