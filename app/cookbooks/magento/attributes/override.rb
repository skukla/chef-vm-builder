#
# Cookbook:: magento
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
  custom_demo: [:structure],
  installation_options: %i[family version minimum_stability directory consumer_list],
  build_options: [:action, :force_install, :sample_data, :modules_to_remove, { deploy_mode: %i[apply mode] }],
  build_hooks: %i[warm_cache enable_media_gallery commands],
  installation_settings: %i[backend_frontname language timezone currency admin_firstname admin_lastname admin_email admin_user admin_password use_rewrites use_secure_frontend use_secure_admin cleanup_database session_save encryption_key]
}

supported_settings.each do |setting_key, setting_data|
  case setting_key
  when :installation_options
    setting_data.each do |option|
      next if node[:application][:options][option].nil?

      if option == :family
        if node[:application][:options][:family].downcase == 'commerce'
          override[:magento][:options][option] = 'enterprise'
        end
      else
        override[:magento][:options][option] = node[:application][:options][option]
      end
    end
  when :build_options
    settings_array = []
    setting_data.each do |option|
      next unless node[:application][:build].is_a? Chef::Node::ImmutableMash

      if option.is_a? Hash
        option.each do |option_key, _field|
          next if node[:application][:build][option_key].nil?

          case option_key
          when :deploy_mode
            # e.g. deploy_mode = production | developer
            if node[:application][:build][option_key].is_a? String
              override[:magento][:build][option_key][:mode] = node[:application][:build][option_key]
              # e.g. deploy_mode = true | false
            elsif (node[:application][:build][option_key].is_a? TrueClass) || (node[:application][:build][option_key].is_a? FalseClass)
              override[:magento][:build][option_key][:apply] = node[:application][:build][option_key]
            end
          end
        end
      else
        next if node[:application][:build][option].nil?

        if node[:application][:build][option].is_a? Chef::Node::ImmutableArray
          node[:application][:build][option].each do |setting|
            settings_array << setting unless setting.empty?
          end
          override[:magento][:build][option] = settings_array
        else
          override[:magento][:build][option] = node[:application][:build][option]
        end
      end
    end
  when :installation_settings
    next unless node[:application][:settings].is_a? Chef::Node::ImmutableMash

    setting_data.each do |option|
      next if node[:application][:settings][option].nil?

      override[:magento][:settings][option] = node[:application][:settings][option]
    end
  when :build_hooks
    next unless node[:application][:build][:hooks].is_a? Chef::Node::ImmutableMash

    setting_data.each do |option|
      next if node[:application][:build][:hooks][option].nil?

      override[:magento][:build][:hooks][option] = node[:application][:build][:hooks][option]
    end
  when :custom_demo
    setting_data.each do |field|
      case field
      when :structure
        override[:magento][:settings][:unsecure_base_url] = "http://#{node[setting_key][field][:website][:base]}/"
        override[:magento][:settings][:secure_base_url] = "https://#{node[setting_key][field][:website][:base]}/"
        override[:magento][:settings][:admin_email] = "admin@#{node[setting_key][field][:website][:base]}"
      end
    end
  end
end
