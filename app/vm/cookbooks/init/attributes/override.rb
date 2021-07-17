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
	custom_demo: %i[structure],
}

settings.each do |group, settings_arr|
	unless node[group].is_a?(Hash) || node[:infrastructure][group].is_a?(Hash)
		next
	end

	settings_arr.each do |setting|
		case group
		when :vm, :custom_demo
			setting_hash = node[group]
		when :os
			setting_hash = node[:infrastructure][group]
		end

		if setting_hash[setting].nil? ||
				(setting_hash[setting].is_a?(String) && setting_hash[setting].empty?)
			next
		end

		override[:init][group][setting] = setting_hash[setting]
	end
end
