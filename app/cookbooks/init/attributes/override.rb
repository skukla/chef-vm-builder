# Cookbook:: init
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings:
# vm: ip, name
# os: update, timezone
# custom_demo: structure{}
#
# frozen_string_literal: true

settings = {
  vm: %i[ip name],
  os: %i[update timezone],
  custom_demo: %i[structure]
}

settings.each do |group, settings_arr|
  next unless node[group].is_a?(Hash) || node[:infrastructure][group].is_a?(Hash)

  settings_arr.each do |setting|
    case group
    when :vm, :custom_demo
      setting_hash = node[group]
    when :os
      setting_hash = node[:infrastructure][group]
    end

    next if setting_hash[setting].nil? ||
            (setting_hash[setting].is_a?(String) && setting_hash[setting].empty?)

    override[:init][group][setting] = setting_hash[setting]
  end
end
