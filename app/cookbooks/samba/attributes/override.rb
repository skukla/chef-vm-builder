#
# Cookbook:: samba
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = %i[use share_list]

supported_settings.each do |setting|
  if node[:infrastructure][:samba].is_a? Chef::Node::ImmutableMash
    next if node[:infrastructure][:samba][setting].nil?

    override[:samba][setting] = node[:infrastructure][:samba][setting]
  else
    next unless (node[:infrastructure][:samba].is_a? TrueClass) || (node[:infrastructure][:samba].is_a? FalseClass)

    override[:samba][:use] = node[:infrastructure][:samba]
  end
end
