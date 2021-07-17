# Cookbook:: samba
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: use,
#                     share_fields: {path public browseable writeable force_user force_group comment}
#
# frozen_string_literal: true

setting = node[:infrastructure][:samba]

override[:samba][:use] = setting if setting.is_a?(TrueClass) || setting.is_a?(FalseClass)
if setting.is_a?(Hash) && !setting.empty?
  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:samba][key] = setting[key]
  end
end
