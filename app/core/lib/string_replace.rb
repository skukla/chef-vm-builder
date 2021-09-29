class StringReplace
	def self.sanitize_base_url(url)
		%w[. -].each { |char| url = url.gsub(char, '_') }
		url
	end
end
