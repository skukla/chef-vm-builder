require_relative 'config'

class DemoStructure
  class << self
    attr_accessor :data
  end
  @data = {}
  @@website_fields = %w[site_code site_url scope]
  @@store_view_fields = %w[store_view_code store_view_url scope]

  def DemoStructure.json
    @data = Config.value('custom_demo/websites')
    self
  end

  def DemoStructure.website_structure_missing?
    json.output.nil?
  end

  def DemoStructure.add_scope(scope)
    @data = @data.map { |site_hash| site_hash.merge({ 'scope' => scope }) }
    self
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
    @data =
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
    @data
  end

  def DemoStructure.find_field(key)
    @data =
      @data
        .flat_map { |tmp_data| tmp_data[key] }
        .reject { |setting| setting.to_s.empty? }
    self
  end

  def DemoStructure.pull_fields(fields_arr)
    @data
      .each_with_object([]) { |hash, arr| arr << hash.slice(*fields_arr) }
      .reject(&:empty?)
  end

  def DemoStructure.vhost_entries
    vhost_data.output
  end

  def DemoStructure.vm_urls
    vhost_data.find_field('url').output
  end

  def DemoStructure.vm_urls_with_protocol
    protocol = Config.url_protocol
    return if protocol.nil?

    vm_urls.map { |url| "#{protocol}#{url}" }
  end

  def DemoStructure.base_url
    vhost_data
      .output
      .select { |record| record['code'] == 'base' }
      .map { |value| value['url'] }
      .first
  end

  def DemoStructure.base_url_with_protocol
    protocol = Config.url_protocol
    return if protocol.nil?

    "#{protocol}#{base_url}"
  end

  def DemoStructure.additional_entries
    vhost_entries.reject { |entry| %w[base default].include?(entry['code']) }
  end

  def DemoStructure.additional_urls
    additional_entries.map { |entry| entry['url'] }
  end
end
