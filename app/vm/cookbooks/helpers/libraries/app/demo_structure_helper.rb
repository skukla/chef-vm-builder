require_relative 'config_helper'

class DemoStructureHelper
	class << self
		attr_accessor :data
	end
	@data = {}
	@website_fields = %w[site_code site_url scope]
	@store_view_fields = %w[store_view_code store_view_url scope]

	def DemoStructureHelper.json
		@data = ConfigHelper.value('custom_demo/structure/websites')
		self
	end

	def DemoStructureHelper.website_structure_missing?
		json.output.nil?
	end

	def DemoStructureHelper.add_scope(scope)
		@data = @data.map { |site_hash| site_hash.merge({ 'scope' => scope }) }
		self
	end

	def DemoStructureHelper.website_data
		json.add_scope('website')
		self
	end

	def DemoStructureHelper.store_data
		website_data.find_field('stores')
		self
	end

	def DemoStructureHelper.store_view_data
		store_data.find_field('store_views').add_scope('stores')
		self
	end

	def DemoStructureHelper.vhost_data
		@data =
			website_data
				.pull_fields(@website_fields)
				.concat(store_view_data.pull_fields(@store_view_fields))
				.map do |record|
					record.transform_keys do |key|
						(key.gsub(key, 'code') if key.include?('code')) ||
							(key.gsub(key, 'url') if key.include?('url')) || key
					end
				end
				.map do |record|
					record.transform_values do |value|
						(value.gsub(value, 'store') if value.include?('stores')) || value
					end
				end
				.reject { |entry| entry['url'].to_s.empty? }
		self
	end

	def DemoStructureHelper.output
		@data
	end

	def DemoStructureHelper.find_field(key)
		@data =
			@data
				.flat_map { |tmp_data| tmp_data[key] }
				.reject { |setting| setting.to_s.empty? }
		self
	end

	def DemoStructureHelper.pull_fields(fields_arr)
		@data
			.each_with_object([]) { |hash, arr| arr << hash.slice(*fields_arr) }
			.reject(&:empty?)
	end

	def DemoStructureHelper.vhost_entries
		vhost_data.output
	end

	def DemoStructureHelper.vm_urls
		vhost_data.find_field('url').output
	end

	def DemoStructureHelper.base_url
		vhost_data
			.output
			.select { |record| record['code'] == 'base' }
			.map { |value| value['url'] }
			.first
	end

	def DemoStructureHelper.base_website_missing?
		base_url.to_s.empty?
	end

	def DemoStructureHelper.additional_entries
		result =
			vhost_entries.reject { |entry| %w[base default].include?(entry['code']) }
		result.empty? ? nil : result
	end

	def DemoStructureHelper.additional_urls
		additional_entries.map { |entry| entry['url'] }
	end
end
