#
# Cookbook:: magento_demo_builder
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :custom_demo => [:custom_modules]
}

supported_settings.each do |top_key, top_array|
    case top_key
    when :custom_demo
        top_array.each do |setting|
            if node[top_key][setting].is_a? Chef::Node::ImmutableMash
                unless node[top_key][setting].nil?
                    node[top_key][setting].each do |custom_module_key, custom_module_value|
                            override[:magento_demo_builder][:custom_module_list] = node[top_key][setting]
                    end
                end
            end
        end
    end
end