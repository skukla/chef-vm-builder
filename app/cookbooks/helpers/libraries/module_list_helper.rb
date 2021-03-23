#
# Cookbook:: helpers
# Library:: module_list_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module ModuleListHelper
  def self.get_module_data(supported_settings, configured_custom_modules)
    module_list = []
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
        end
        module_list << custom_module_hash
      end
      module_list.each do |module_data|
        data_hash[module_data[:package_name]] = module_data
      end
      data_hash
    end
  end

  def self.clean_up_module_data(module_directory)
    `cd #{module_directory} && find . -name '.DS_Store' -type f -delete`
    puts '.DS_Store files removed'

    `cd #{module_directory} && find . -name '.gitignore' -type f -delete`
    puts '.gitignore files removed'
  end

  def self.build_require_string(module_list)
    module_arr = []
    module_list.each do |_key, value|
      next unless value.is_a? Hash

      value.each do
        package_string = value['package_name']
        package_string = [package_string, value['package_version']].join(':') unless value['package_version'].nil?
        module_arr << package_string
      end
    end
    module_arr.uniq.join(' ')
  end
end
