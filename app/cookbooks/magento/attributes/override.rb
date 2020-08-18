#
# Cookbook:: magento
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :installation_options => [:family, :version, :minimum_stability, :directory, :consumer_list],
    :build_options => [:clear_cache, :action, :force_install, :sample_data, :modules_to_remove, :deploy_mode => [:apply, :mode]],
    :installation_settings => [:backend_frontname, :unsecure_base_url, :secure_base_url, :language, :timezone, :currency, :admin_firstname, :admin_lastname, :admin_email, :admin_user, :admin_password, :use_rewrites, :use_secure_frontend,  :use_secure_admin, :cleanup_database, :session_save, :encryption_key]
}

supported_settings.each do |setting_key, setting_data|
    case setting_key
    when :installation_options
        setting_data.each do |option|
            next if node[:application][:installation][:options][option].nil?
            if option == :family
                if node[:application][:installation][:options][:family].downcase == "commerce"
                    override[:magento][:installation][:options][option] = "enterprise"
                end
            else
                override[:magento][:installation][:options][option] = node[:application][:installation][:options][option]
            end
        end
    when :build_options
        settings_array = Array.new
        setting_data.each do |option|
            next unless node[:application][:installation][:build].is_a? Chef::Node::ImmutableMash
            if option.is_a? Hash
                option.each do |option_key, field|
                    next if node[:application][:installation][:build][option_key].nil?
                    case option_key
                    when :deploy_mode
                        # e.g. deploy_mode = production | developer
                        if (node[:application][:installation][:build][option_key].is_a? String)
                            override[:magento][:installation][:build][option_key][:mode] = node[:application][:installation][:build][option_key]
                        # e.g. deploy_mode = true | false
                        elsif (node[:application][:installation][:build][option_key].is_a? TrueClass) || (node[:application][:installation][:build][option_key].is_a? FalseClass)
                            override[:magento][:installation][:build][option_key][:apply] = node[:application][:installation][:build][option_key]
                        end
                    else
                        if field.is_a? Array
                            field.each do |value|
                                next if node[:application][:installation][:build][option_key][value].nil?
                                override[:magento][:installation][:build][option_key][value] = node[:application][:installation][:build][option_key][value]
                            end
                        end
                    end
                end
            else
                next if node[:application][:installation][:build][option].nil?
                if node[:application][:installation][:build][option].is_a? Chef::Node::ImmutableArray
                    node[:application][:installation][:build][option].each do |setting| 
                        settings_array << setting if !setting.empty?
                    end
                    override[:magento][:installation][:build][option] = settings_array
                else
                    override[:magento][:installation][:build][option] = node[:application][:installation][:build][option]
                end
            end
        end
    when :installation_settings
        next unless node[:application][:installation][:settings].is_a? Chef::Node::ImmutableMash
        setting_data.each do |option|
            next if node[:application][:installation][:settings][option].nil?
            override[:magento][:installation][:settings][option] = node[:application][:installation][:settings][option]
        end
    end
end