#
# Cookbook:: magento_custom_modules
# Resource:: custom_module_config
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :custom_module_config
property :name,                   String, name_property: true
property :module_list,            Hash
property :exclude_list,           Array, default: Array.new

action :process_configuration do
    selected_modules = new_resource.module_list.select{|key, data| !new_resource.exclude_list.include? data[:name] }
    unless selected_modules.empty?
        new_resource.module_list.each do |module_key, module_data|    
            unless module_data[:configuration].nil?
                module_data[:configuration].each do |setting|
                    magento_cli "Configuring custom module setting : #{setting[:path]}" do
                        action :config_set
                        config_scope "default"
                        config_path "#{setting[:path]}"
                        config_value "#{setting[:value]}"
                    end
                end
            end
        end
    end
end
