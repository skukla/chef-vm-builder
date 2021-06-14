#
# Cookbook:: composer
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
  composer_auth: %i[public_key private_key github_token],
  composer_app: %i[version clear_composer_cache]
}

supported_settings.each do |setting_key, setting_data|
  case setting_key
  when :composer_auth
    next unless node[:application][:authentication][:composer].is_a? Chef::Node::ImmutableMash

    setting_data.each do |option|
      next if node[:application][:authentication][:composer][option].empty?

      unless node[:application][:authentication][:composer][option].nil?
        override[:composer][option] = node[:application][:authentication][:composer][option]
      end
    end
  when :composer_app
    if node[:infrastructure][:composer].is_a? Chef::Node::ImmutableMash
      setting_data.each do |option|
        unless node[:infrastructure][:composer][option].nil?
          override[:composer][option] = node[:infrastructure][:composer][option]
        end
      end
    elsif node[:infrastructure][:composer].is_a? String
      override[:composer][:version] = node[:infrastructure][:composer] unless node[:infrastructure][:composer].empty?
    end
  end
end
