require_relative 'config'

class DemoStructure
	class << self
		attr_accessor :data
	end
	@@data = { result: '' }
	@@website_fields = %w[site_code site_url]
	@@store_view_fields = %w[store_view_code store_view_url]

	def DemoStructure.json
		@@data[:result] = Config.setting('custom_demo/structure/websites')
		self
	end

	def DemoStructure.website_structure_missing?
		json.output.nil?
	end

	def DemoStructure.website_data
		json.add_scope('website')
		self
	end

	def DemoStructure.store_data
		website_data.find_field('stores')
		self
	end

	def DemoStructure.store_view_data
		store_data.find_field('store_views').add_scope('stores')
		self
	end

	def DemoStructure.vhost_data
		@@data[:result] =
			website_data
				.pull_fields(@@website_fields)
				.concat(store_view_data.pull_fields(@@store_view_fields))
				.map do |record|
					record.transform_keys do |key|
						(key.gsub(key, 'code') if key.include?('code')) ||
							(key.gsub(key, 'url') if key.include?('url')) || key
					end
				end
				.reject { |entry| entry['url'].to_s.empty? }
		self
	end

	def DemoStructure.output
		@@data[:result]
	end

	def DemoStructure.add_scope(scope)
		@@data[:result] =
			@@data[:result].map { |site_hash| site_hash.merge({ scope: scope }) }
		self
	end

	def DemoStructure.find_field(key)
		@@data[:result] =
			@@data[:result]
				.flat_map { |tmp_data| tmp_data[key] }
				.reject { |setting| setting.to_s.empty? }
		self
	end

	def DemoStructure.pull_fields(fields_arr)
		@@data[:result]
			.each_with_object([]) { |hash, arr| arr << hash.slice(*fields_arr) }
			.reject(&:empty?)
	end

	def DemoStructure.vhost_entries
		vhost_data.output
	end

	def DemoStructure.vm_urls
		vhost_data.find_field('url').output
	end

	def DemoStructure.base_url
		vhost_data
			.output
			.select { |record| record['code'] == 'base' }
			.map { |value| value['url'] }
			.first
	end

	def DemoStructure.base_website_missing?
		base_url.to_s.empty?
	end

	def DemoStructure.additional_entries
		vhost_entries.reject { |entry| %w[base default].include?(entry['code']) }
	end

	def DemoStructure.additional_urls
		additional_entries.map { |entry| entry['url'] }
	end
end
