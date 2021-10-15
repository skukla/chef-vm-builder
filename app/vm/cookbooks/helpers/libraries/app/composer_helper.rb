# Cookbook:: helpers
# Library:: app/composer_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ComposerHelper
	def ComposerHelper.build_require_string(module_list)
		module_list
			.each_with_object([]) do |m, arr|
				if StringReplaceHelper.parse_source_url(m['source']).nil? &&
						m['source'].include?('/')
					req_str = m['source']
				end

				unless StringReplaceHelper.parse_source_url(m['source']).nil?
					req_str = m['package_name']
				end

				req_str = [req_str, m['version']].join(':') unless m['version'].nil?
				arr << req_str
			end
			.join(' ')
	end
end
