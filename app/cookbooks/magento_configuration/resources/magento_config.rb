#
# Cookbook:: magento_configuration
# Resource:: magento_config
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_config
property :name,                   String, name_property: true
property :web_root,               String, default: node[:magento][:web_root]
property :config_group,           String
property :config_paths,           Array
property :config_data,            Hash
property :admin_users,            Hash, default: node[:magento_configuration][:admin_users]
property :shares,                 Hash, default: node[:magento_configuration][:samba_shares]
property :user,                   String, default: node[:magento_configuration][:user]
property :group,                  String, default: node[:magento_configuration][:user]
property :use_elasticsearch,      String, default: node[:magento][:elasticsearch][:use].to_s

action :process_configuration do
    new_resource.config_paths.each do |config_path|
        config_setting = new_resource.config_data.dig(*config_path.split("/"))
        # Website/Store-view-scoped settings
        if config_setting.is_a? Chef::Node::ImmutableMash
            ["website", "store_view"].each do |config_scope|
                if config_setting.has_key?(config_scope)
                    config_setting[config_scope].each do |config_scope_code, config_value|
                        unless config_value.nil? || ((config_value.is_a? String) && config_value.empty?)
                            # Base Settings
                            if new_resource.config_group == "base" && !config_path.include?("btob") && !config_path.include?("search")
                                magento_cli "Configuring #{new_resource.config_group} #{config_scope} setting for #{config_scope_code}: #{config_path}" do
                                    action :config_set
                                    config_path "#{config_path}"
                                    config_scope "#{config_scope}"
                                    config_scope_code "#{config_scope_code}"
                                    config_value "#{config_value}"
                                end
                            
                            # B2B Settings
                            elsif new_resource.config_group == "b2b" && config_path.include?("btob")
                                magento_cli "Configuring #{new_resource.config_group} #{config_scope} setting for #{config_scope_code}: #{config_path}" do
                                    action :config_set
                                    config_path "#{config_path}"
                                    config_scope "#{config_scope}"
                                    config_scope_code "#{config_scope_code}"
                                    config_value "#{config_value}"
                                end

                            # Search Settings
                            elsif new_resource.config_group == "search" && config_path.include?("search")
                                magento_cli "Configuring #{new_resource.config_group} #{config_scope} setting for #{config_scope_code}: #{config_path}" do
                                    action :config_set
                                    config_path "#{config_path}"
                                    config_scope "#{config_scope}"
                                    config_scope_code "#{config_scope_code}"
                                    config_value "#{config_value}"
                                end
                            end
                        end
                    end
                end
            end
        # Default-scoped settings
        else
            unless config_setting.nil? || ((config_setting.is_a? String) && config_setting.empty?)
                # Base settings
                if new_resource.config_group == "base" && !config_path.include?("btob") && !config_path.include?("search")
                    magento_cli "Configuring default #{new_resource.config_group} setting for: #{config_path}" do
                        action :config_set
                        config_scope "default"
                        config_path "#{config_path}"
                        config_value "#{config_setting}"
                    end

                # B2B settings
                elsif new_resource.config_group == "b2b" && config_path.include?("btob")
                    magento_cli "Configuring default #{new_resource.config_group} setting for: #{config_path}" do
                        action :config_set
                        config_scope "default"
                        config_path "#{config_path}"
                        config_value "#{config_setting}"
                    end

                # Search settings
                elsif new_resource.config_group == "search" && config_path.include?("search")
                    magento_cli "Configuring default #{new_resource.config_group} setting for: #{config_path}" do
                        action :config_set
                        config_scope "default"
                        config_path "#{config_path}"
                        config_value "#{config_setting}"
                    end
                end
            end
        end
    end
end

action :process_admin_users do
    new_resource.admin_users.each do |field, value|
        magento_cli "Configure admin user : #{value[:first_name]} #{value[:last_name]}" do
            action :create_admin_user
            admin_username "#{value[:username]}"
            admin_password "#{value[:password]}"
            admin_email "#{value[:email]}"
            admin_firstname "#{value[:first_name]}"
            admin_lastname "#{value[:last_name]}"
        end
    end
end

action :create_media_drops do
    [:product_media_drop, :content_media_drop].each do |drop_directory|
        if new_resource.shares.has_key?(drop_directory)
            if new_resource.shares[drop_directory].is_a? String and !new_resource.shares[drop_directory].empty?
                media_drop_path = new_resource.shares[drop_directory]
            elsif new_resource.shares[drop_directory].has_key?(:path) && !new_resource.shares[drop_directory][:path].empty?
                media_drop_path = new_resource.shares[drop_directory][:path]
            end
            directory "Media Drop" do
                path "#{media_drop_path}"
                owner "#{new_resource.user}"
                group "#{new_resource.group}"
                mode "777"
                recursive true
                not_if { Dir.exist?("#{media_drop_path}") }
            end
        end
    end
end