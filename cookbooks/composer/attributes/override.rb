#
# Cookbook:: composer
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :magento_build => [:clear_composer_cache],
    :credentials => [:github_token, :username, :password]
}

supported_settings.each do |setting_key, setting_data|
    case setting_key
    when :magento_build
        next unless node[:application][:installation][:build].is_a? Chef::Node::ImmutableMash
        setting_data.each do |option|
            unless node[:application][:installation][:build][option].nil?
                override[:composer][option] = node[:application][:installation][:build][option]
            end
        end
    when :credentials
        next unless node[:application][:authentication][:composer].is_a? Chef::Node::ImmutableMash
        setting_data.each do |option|
            next if node[:application][:authentication][:composer][option].empty?
            unless node[:application][:authentication][:composer][option].nil?
                override[:composer][option] = node[:application][:authentication][:composer][option]
            end
        end
    end
end