#
# Cookbook:: magento_demo_builder
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
  custom_demo: %i[custom_modules data_packs]
}

supported_settings.each do |top_key, top_array|
  case top_key
  when :custom_demo
    top_array.each do |setting|
      next unless node[top_key][setting].is_a? Chef::Node::ImmutableMash

      next if node[top_key][setting].nil?

      node[top_key][setting].each do |_custom_module_key, _custom_module_value|
        override[:magento_demo_builder][setting] = node[top_key][setting]
      end
    end
  end
end
