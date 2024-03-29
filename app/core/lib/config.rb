require 'pathname'
require 'json'

require_relative 'app'
require_relative 'entry'

class Config
  class << self
    attr_reader :json_file_path, :json_filename
  end
  @search_path = 'infrastructure/search_engine'
  @json_file_path = File.join('project', 'config')
  @json_filename = 'config.json'

  def Config.remove_blanks(hash_or_array)
    p =
      proc do |*args|
        v = args.last
        v.delete_if(&p) if v.respond_to? :delete_if
        v.nil? || v.respond_to?(:'empty?') && v.empty?
      end
    hash_or_array.delete_if(&p)
  end

  def Config.json
    config_json_file = Entry.path(File.join(@json_file_path, @json_filename))

    return nil unless Entry.file_exists?(config_json_file)

    remove_blanks(JSON.parse(File.read(config_json_file)))
  end

  def Config.value(setting_path)
    return nil if json.nil?

    json.dig(*setting_path.split('/'))
  end

  def Config.setting(path, key = nil)
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

  def Config.vm_name
    vm_name = setting('vm/name')

    return nil if vm_name.nil?

    vm_name
      .gsub(/[^a-zA-Z0-9]/, ' ')
      .strip
      .split(' ')
      .reduce { |new_string, chars| new_string += "-#{chars}" }
  end

  def Config.provider
    setting('vm/provider')
  end

  def Config.provisioner_type
    setting('provisioner/type')
  end

  def Config.provisioner_version
    setting('provisioner/version')
  end

  def Config.provisioner_install?
    setting('provisioner/install')
  end

  def Config.base_box
    setting('remote_machine/base_box')
  end

  def Config.gui
    setting('remote_machine/gui')
  end

  def Config.build_action
    setting('application/build/action')
  end

  def Config.search_engine_type
    setting(@search_path, 'type')
  end

  def Config.wipe_search_engine?
    setting = setting(@search_path, 'wipe')
    return false unless setting.is_a?(TrueClass) || setting.is_a?(FalseClass)
    setting
  end

  def Config.restore_mode
    setting('application/build/restore', 'mode')
  end

  def Config.build_action_list
    %w[
      install
      force_install
      restore
      reinstall
      update_all
      update_app
      update_data
      update_urls
    ]
  end

  def Config.search_engine_type_list
    %w[elasticsearch live_search mysql]
  end

  def Config.restore_mode_list
    %w[separate merge]
  end

  def Config.elasticsearch_requested?
    if search_engine_type == 'elasticsearch' || search_engine_type.nil?
      return true
    end
    false
  end

  def Config.url_protocol(area = nil)
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
