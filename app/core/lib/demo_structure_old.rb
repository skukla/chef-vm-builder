require_relative 'config'

class DemoStructure
	@data = Config.setting('custom_demo/structure/websites')
	@website_fields = %w[site_code site_url]
	@store_view_fields = %w[store_view_code store_view_url]

	def DemoStructure.website_structure_missing?
		@data.nil? || @data.empty?
	end

	def DemoStructure.add_scope(data, scope)
		data.map { |site_hash| site_hash.merge({ scope: scope }) }
	end

	def DemoStructure.find_field(data, key)
		data
			.flat_map { |tmp_data| tmp_data[key] }
			.reject { |setting| setting.to_s.empty? }
	end

	def DemoStructure.pull_fields(data, fields_arr)
		data
			.each_with_object([]) { |hash, arr| arr << hash.slice(*fields_arr) }
			.reject { |field| field.to_s.empty? }
	end

	def DemoStructure.website_data
		add_scope(@data, 'website')
	end

	def DemoStructure.store_data
		find_field(website_data, 'stores')
	end

	def DemoStructure.store_view_data
		add_scope(find_field(store_data, 'store_views'), 'stores')
	end

	def DemoStructure.vhost_data
		pull_fields(website_data, @website_fields)
			.concat(pull_fields(store_view_data, @store_view_fields))
			.map do |record|
				record.transform_keys do |key|
					(key.gsub(key, 'code') if key.include?('code')) ||
						(key.gsub(key, 'url') if key.include?('url')) || key
				end
			end
			.reject { |entry| entry['url'].to_s.empty? }
	end

	def DemoStructure.vm_urls
		find_field(vhost_data, 'url')
	end

	def DemoStructure.base_website_missing?
		!find_field(vhost_data, 'code').include?('base')
	end

	def DemoStructure.additional_entries
		vhost_data.reject { |entry| %w[base default].include?(entry['code']) }
	end
end
