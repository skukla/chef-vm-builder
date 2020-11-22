#
# Cookbook:: helpers
# Library:: module_list_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module ModuleListHelper
  def self.get_module_data(supported_modules, supported_settings, configured_custom_modules)
    module_list = []
    user_configurations = []
    data_hash = {}
    unless configured_custom_modules.nil?
      configured_custom_modules.each do |_custom_key, custom_value|
        custom_module_hash = {}
        if !custom_value.is_a? Hash
          package_name = custom_value
          if custom_value.include?('/')
            vendor = custom_value.split('/')[0]
            module_name = custom_value.split('/')[1]
          else
            package_name = custom_value
            vendor = custom_value
          end
          custom_module_hash[:package_name] = package_name
          custom_module_hash[:vendor] = vendor
          custom_module_hash[:module_name] = module_name
        else
          supported_settings.each do |setting|
            case setting
            when :name
              unless custom_value[setting].nil?
                custom_module_hash[:package_name] = custom_value[setting]
                if custom_value[setting].include?('/')
                  custom_module_hash[:vendor] = custom_value[setting].split('/')[0]
                  custom_module_hash[:module_name] = custom_value[setting].split('/')[1]
                else
                  custom_module_hash[:vendor] = custom_value[setting]
                  custom_module_hash[:module_name] = custom_value[setting]
                end
              end
            when :version
              custom_module_hash[:package_version] = if custom_value[setting].nil?
                                                       'dev-master'
                                                     else
                                                       custom_value[setting]
                                                     end
            else
              custom_module_hash[setting] = custom_value[setting]
            end
          end
          if custom_value.key?(:configuration)
            supported_modules.each do |_supported_key, supported_value|
              supported_value[:config_paths].each do |config_path|
                configuration_setting = {}
                if config_path.include?('enable_autofill')
                  configuration_setting[:path] = config_path
                  configuration_setting[:value] = 1
                  user_configurations << configuration_setting
                end
                setting_value = custom_value[:configuration].dig(*config_path.split('/').map(&:to_sym))
                next if setting_value.nil?

                configuration_setting[:path] = config_path
                configuration_setting[:value] = setting_value
                user_configurations << configuration_setting
              end
              custom_module_hash[:configuration] = user_configurations
            end
          end
        end
        module_list << custom_module_hash
      end
      module_list.each do |module_data|
        data_hash[module_data[:package_name]] = module_data
      end
      data_hash
    end
  end
end
