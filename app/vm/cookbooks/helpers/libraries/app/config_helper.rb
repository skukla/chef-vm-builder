# Cookbook:: helpers
# Library:: app/config_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

require 'pathname'
require 'json'

class ConfigHelper
  class << self
    attr_reader :build_action_arr
  end
  @app_root = AppHelper.root
  @json_file_path = File.join('helpers', 'libraries')
  @json_filename = 'config.json'

  def ConfigHelper.remove_blanks(hash_or_array)
    p =
      proc do |*args|
        v = args.last
        v.delete_if(&p) if v.respond_to? :delete_if
        v.nil? || v.respond_to?(:'empty?') && v.empty?
      end
    hash_or_array.delete_if(&p)
  end

  def ConfigHelper.json
    config_json_file =
      EntryHelper.path(File.join(@json_file_path, @json_filename))

    return nil unless EntryHelper.file_exists?(config_json_file)

    self.remove_blanks(JSON.parse(File.read(config_json_file)))
  end

  def ConfigHelper.value(setting_path)
    return nil if json.nil?

    json.dig(*setting_path.split('/'))
  end

  def ConfigHelper.setting(path, key = nil)
    setting = value(path)

    return false if setting.is_a?(FalseClass)
    return true if setting.is_a?(TrueClass)

    if setting.nil? || setting.empty? ||
         (
           setting.is_a?(Hash) &&
             (setting[key].nil? || setting[key].to_s.empty?)
         )
      return nil
    end

    return setting[key] if (setting.is_a?(Hash) && !setting[key].to_s.empty?)

    setting if setting.is_a?(String)
  end

  def ConfigHelper.provider
    setting('vm/provider')
  end

  def ConfigHelper.search_engine_type
    setting('infrastructure/search_engine', 'type')
  end

  def ConfigHelper.url_protocol(area = nil)
    usf = value('application/settings/use_secure_frontend')
    usa = value('application/settings/use_secure_admin')

    if (
         area == nil || (usf.nil? && usa.nil?) ||
           (area == 'storefront' && !usf) || (area == 'admin' && !usa)
       )
      return 'http://'
    end

    'https://' if (area == 'storefront' && usf) || (area == 'admin' && usa)
  end
end
