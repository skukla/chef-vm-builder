class ComposerHelper
	def ComposerHelper.build_require_string(module_list)
		module_list
			.select { |m| m['source'].nil? || m['source'].include?('github') }
			.each_with_object([]) do |m, arr|
				req_str = m['name']
				req_str = [req_str, m['version']].join(':') unless m['version'].nil?
				arr << req_str
			end
			.join(' ')
	end
end
