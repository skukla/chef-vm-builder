#
# Cookbook:: magento_restore
# Attribute:: override
#
# Currently this is unused
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :backup => [:version, :download_url]
}

supported_settings.each do |top_key, top_array|
    case top_key
    when :backup
        top_array.each do |setting|
            if node[:custom_demo][top_key].is_a? Chef::Node::ImmutableMash
                unless node[:custom_demo][top_key][setting].nil?
                    node[:custom_demo][top_key].each do |key, value|
                        override[:magento_restore][:remote_backup_data][key] = node[:custom_demo][:backup][key]
                    end
                end
            elsif node[:custom_demo][top_key].is_a? String
                case setting
                when :version
                    override[:magento_restore][:remote_backup_data][setting] = node[:custom_demo][:backup]
                end
            end
        end
    end
end