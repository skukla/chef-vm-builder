#
# Cookbook:: magento_custom_modules
# Resource:: custom_module_config
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :custom_module_config
provides :custom_module_config

property :name,                 String, name_property: true
property :config_data,          Hash
property :use_elasticsearch,    [TrueClass, FalseClass], default: node[:magento_custom_modules][:elasticsearch][:use]

action :process_configuration do
  unless new_resource.config_data.empty?
    new_resource.config_data.each do |module_key, module_data|
      next if module_key.include?('elasticsuite') && new_resource.use_elasticsearch == false

      next if module_data[:configuration].nil?

      module_data[:configuration].each do |setting|
        magento_cli "Configuring custom module setting : #{setting[:path]}" do
          action :config_set
          config_scope 'default'
          config_path setting[:path]
          config_value setting[:value]
        end
      end
    end
  end
end
