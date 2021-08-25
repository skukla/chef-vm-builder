# Cookbook:: helpers
# Library:: value
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module ValueHelper
	def self.process_value(value)
		case value.to_s
		when 'true'
			return 1
		when 'false'
			return 0
		end
		value
	end
end
