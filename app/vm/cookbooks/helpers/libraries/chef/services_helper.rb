# Cookbook:: helpers
# Library:: services_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ServicesHelper
	def ServicesHelper.read_production_key
		key_file =
			"#{Chef.node[:magento][:csc_options][:key_path]}/privateKey-production.pem"
		key_value = ''
		if File.exist?(key_file)
			File.readlines(key_file).each { |line| key_value += line }
		end
		key_value.chomp
	end
end
