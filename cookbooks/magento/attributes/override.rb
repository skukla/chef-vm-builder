#
# Cookbook:: magento
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :infrastructure => {
        :database => [:host, :user, :password, :name],
    },
    :application => {
        :installation => {
            :options => [
                :family, 
                :version,
                :directory,
                :install,
                :sample_data,
                :modules_to_remove,
                :download => [:base_code, :b2b_code, :custom_modules],
                :deploy_mode => [:apply, :mode],
                :patches => [:apply, :repository],
                :configuration => [:base, :b2b, :custom_modules, :admin_users]
            ],
            :settings => [
                :backend_frontname,
                :unsecure_base_url,
                :secure_base_url,
                :language,
                :timezone,
                :currency,
                :admin_firstname,
                :admin_lastname,
                :admin_email,
                :admin_user,
                :admin_password,
                :use_rewrites,
                :use_secure_frontend, 
                :use_secure_admin,
                :cleanup_database,
                :session_save,
                :encryption_key
            ]
        }
    }
}

# Helper method
def process_value(user_value)
    if user_value == true
        return 1
    elsif user_value == false
        return 0
    else
        return user_value
    end
end

supported_settings.each do |top_key, top_hash|
    top_hash.each do |setting_key, setting_value|
        if !node[top_key].dig(setting_key).nil?
            case top_key
            when :infrastructure
                setting_value.each do |field_value|
                    unless node[top_key][setting_key].dig(field_value).nil?
                        override[:magento][setting_key][field_value] = node[top_key][setting_key].dig(field_value)
                    end
                end
            when :application
                setting_value.each do |field_key, field_value|
                    if field_key == :options
                        field_value.each do |option|
                            if option.is_a? Hash
                                option.each do |option_key, option_value|
                                    unless node[top_key][setting_key][field_key].dig(option_key).nil?
                                        override[:magento][setting_key][field_key][option_key] = node[top_key][setting_key][field_key].dig(option_key)
                                    end
                                end     
                            else
                                # Single keys above that may have array values in config.json
                                if node[top_key][setting_key][field_key].dig(option).is_a? Chef::Node::ImmutableArray
                                    option_values_array = node[top_key][setting_key][field_key].dig(option)
                                    option_values_array.each do |option_value|
                                        unless node[top_key][setting_key][field_key].dig(option).nil?
                                            override[:magento][setting_key][field_key][option] = node[top_key][setting_key][field_key].dig(option)
                                        end
                                    end
                                # Single keys which have single values in config.json
                                else
                                    unless node[top_key][setting_key][field_key].dig(option).nil?
                                        override[:magento][setting_key][field_key][option] = node[top_key][setting_key][field_key].dig(option)
                                    end
                                end
                            end
                        end
                    elsif field_key == :settings
                        field_value.each do |option_value|
                            unless node[top_key][setting_key][field_key].dig(option_value).nil?
                                override[:magento][setting_key][field_key][option_value] = node[top_key][setting_key][field_key].dig(option_value)
                            end
                        end
                    end
                end
            end            
        end
    end
end