#
# Cookbook:: init
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :os => [:update, :timezone],
    :vm => [:ip, :name],
    :webserver => :type,
    :magento_build => :web_root,
    :custom_demo => :structure
}

supported_settings.each do |setting_key, setting_data|
    case setting_key
    when :os
        next unless node[:infrastructure][setting_key].is_a? Chef::Node::ImmutableMash
        setting_data.each do |option|
            next if node[:infrastructure][setting_key][option].nil?
            override[:init][setting_key][option] = node[:infrastructure][setting_key][option]
        end
    when :vm
        next unless node[setting_key].is_a? Chef::Node::ImmutableMash
        setting_data.each do |option|
            next if node[setting_key][option].nil? || node[setting_key][option].empty?
            override[:init][setting_key][option] = node[setting_key][option]
        end
    when :webserver
        if node[:infrastructure][setting_key].is_a? Chef::Node::ImmutableMash
            setting_data.each do |option|
                next if node[:infrastructure][setting_key][option].nil?
                override[:init][setting_key][option] = node[:infrastructure][setting_key][option]
            end
        else
            unless node[:infrastructure][setting_key].nil? || node[:infrastructure][setting_key].empty?
                override[:init][setting_key][:type] = node[:infrastructure][setting_key]
            end
        end
    when :custom_demo
        next if node[setting_key][setting_data].nil?
        override[:init][setting_key][setting_data] = node[setting_key][setting_data]
    end
end