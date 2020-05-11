#
# Cookbook:: magento
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :database => [:host, :user, :password, :name],
    :installation_options => [:family, :version, :minimum_stability, :directory],
    :build_options => [:clear_cache, :install, :base_code, :b2b_code, :custom_modules, :sample_data, :modules_to_remove, :deploy_mode => [:apply, :mode], :patches => [:apply, :repository_url], :configuration => [:base, :b2b, :custom_modules, :admin_users]],
    :installation_settings => [:backend_frontname, :unsecure_base_url, :secure_base_url, :language, :timezone, :currency, :admin_firstname, :admin_lastname, :admin_email, :admin_user, :admin_password, :use_rewrites, :use_secure_frontend,  :use_secure_admin, :cleanup_database, :session_save, :encryption_key]
}

# Helper method
def process_value(user_value)
    return 1 if user_value == true
    return 0 if user_value == false
    return user_value
end

supported_settings.each do |setting_key, setting_data|
    case setting_key
    when :database
        next unless node[:infrastructure][setting_key].is_a? Chef::Node::ImmutableMash
        setting_data.each do |option|
            next if (node[:infrastructure][setting_key][option].nil?) || (node[:infrastructure][setting_key][option].empty?)
            override[:magento][setting_key][option] = node[:infrastructure][setting_key][option]
        end
    when :installation_options
        setting_data.each do |option|
            next if node[:application][:installation][:options][option].nil? || node[:application][:installation][:options][option].empty?
            override[:magento][:installation][:options][option] = node[:application][:installation][:options][option]
        end
    when :build_options
        settings_array = Array.new
        setting_data.each do |option|
            next unless node[:application][:installation][:build].is_a? Chef::Node::ImmutableMash
            if option.is_a? Hash
                option.each do |option_key, field|
                    next if node[:application][:installation][:build][option_key].nil? || ((node[:application][:installation][:build][option_key].is_a? String) && (node[:application][:installation][:build][option_key].empty?))
                    if field.is_a? Array
                        field.each do |value|
                            next if node[:application][:installation][:build][option_key][value].nil? || ((node[:application][:installation][:build][option_key][value].is_a? String) && (node[:application][:installation][:build][option_key][value].empty?))        
                            override[:magento][:installation][:build][option_key][value] = node[:application][:installation][:build][option_key][value]
                        end
                    end
                end
            else
                next if ((node[:application][:installation][:build][option].nil?) || (node[:application][:installation][:build][option].is_a? String) && (node[:application][:installation][:build][option].empty?))
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
            next if (node[:application][:installation][:settings][option].nil?) || ((node[:application][:installation][:settings][option].is_a? String) && (node[:application][:installation][:settings][option].empty?))
            override[:magento][:installation][:settings][option] = node[:application][:installation][:settings][option]
        end
    end
end