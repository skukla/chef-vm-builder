#
# Cookbook:: elasticsearch
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = %i[use host version memory port plugins]

supported_settings.each do |setting|
  if node[:infrastructure][:elasticsearch].is_a? Chef::Node::ImmutableMash
    next if node[:infrastructure][:elasticsearch][setting].nil?

    override[:elasticsearch][setting] = if setting == :memory
                                          node[:infrastructure][:elasticsearch][:memory].downcase
                                        else
                                          node[:infrastructure][:elasticsearch][setting]
                                        end
  else
    unless (node[:infrastructure][:elasticsearch].is_a? TrueClass) || (node[:infrastructure][:elasticsearch].is_a? FalseClass)
      next
    end

    override[:elasticsearch][:use] = node[:infrastructure][:elasticsearch]
  end
end
