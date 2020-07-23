#
# Cookbook:: ssl
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [
    :port, 
    :key_size,
    :certificate_days,
    :ssl_directory,
    :private_key_file,
    :ca_certificate_file,
    :ca_serial_file,
    :csr_configuration_file,
    :csr_file,
    :server_private_key_file,
    :extension_file,
    :server_certificate_file,
    :chainfile,
    :organization,
    :organizational_unit,
    :locality,
    :region, 
    :country
]

if node[:infrastructure].is_a? Chef::Node::ImmutableMash
    unless node[:infrastructure][:ssl].nil?
        if node[:infrastructure][:ssl].is_a? Chef::Node::ImmutableMash
            supported_settings.each do |option|
                unless node[:infrastructure][:ssl][option].nil?
                    override[:ssl][option] = node[:infrastructure][:ssl][option]    
                end
            end
        end
    end
end