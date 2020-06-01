#
# Cookbook:: magento_custom_modules
# Resource:: custom_module_config
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :custom_module_config
property :name,                       String, name_property: true
property :module_list,                Hash
property :use_elasticsearch,          String, default: node[:magento][:elasticsearch][:use].to_s

action :process_configuration do
    unless new_resource.module_list.empty?
        new_resource.module_list.each do |module_key, module_data|    
            next if (module_key.include?("elasticsuite") && new_resource.use_elasticsearch == "false")
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
