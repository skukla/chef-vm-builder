#
# Cookbook:: composer
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :credentials => [:github_token, :public_key, :private_key],
    :composer => [:version, :clear_composer_cache],
}

supported_settings.each do |setting_key, setting_data|
    case setting_key
    when :composer
        if node[:infrastructure][setting_key].is_a? Chef::Node::ImmutableMash
            setting_data.each do |option|
                unless node[:infrastructure][setting_key][option].nil?
                    override[:composer][option] = node[:infrastructure][setting_key][option]
                end
            end
        elsif node[:infrastructure][setting_key].is_a? String
            unless node[:infrastructure][setting_key].empty?
                override[setting_key][:version] = node[:infrastructure][setting_key]
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