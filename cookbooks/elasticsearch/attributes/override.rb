#
# Cookbook:: elasticsearch
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:use, :version, :memory, :port, :plugins]

if node[:infrastructure][:elasticsearch].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting|
        if node[:infrastructure][:elasticsearch].has_key?(setting)
            unless node[:infrastructure][:elasticsearch][setting].nil?
                if setting == :memory
                    override[:elasticsearch][setting] = node[:infrastructure][:elasticsearch][:memory].downcase
                else
                    override[:elasticsearch][setting] = node[:infrastructure][:elasticsearch][setting]
                end
            end
        end
    end
elsif node[:infrastructure].has_key?(:elasticsearch)
    unless node[:infrastructure][:elasticsearch].nil?
        override[:elasticsearch][:use] = node[:infrastructure][:elasticsearch]
    end
end