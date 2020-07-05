#
# Cookbook:: ssh
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = {
    :private_keys => {
        :allowed_keys => [],
        :configured_keys => []
    },
    :public_keys => {
        :allowed_keys => [],
        :configured_keys => []
    }
}
override[:ssh][:private_keys][:files] = Array.new
override[:ssh][:public_keys][:files] = Array.new
override[:ssh][:authorized_keys][:files] = Array.new

if node[:application][:authentication][:ssh].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |key_type, setting_data|
        next if node[:application][:authentication][:ssh][key_type].nil?
        if !node[:application][:authentication][:ssh][key_type].is_a? Chef::Node::ImmutableArray
            supported_settings[key_type][:configured_keys] << node[:application][:authentication][:ssh][key_type]
        else
            node[:application][:authentication][:ssh][key_type].each do |configured_key|
                supported_settings[key_type][:configured_keys] << configured_key
            end
        end
        key_type == :private_keys ? key_check = "PRIVATE KEY" : key_check = "ssh-rsa"
        files_in_folder = Dir["#{node[:ssh][key_type][:file_path]}/*"]
        files_in_folder.each do |key_file|
            key_file_content = File.readlines("#{key_file}")[0]
            next unless key_file_content.include?(key_check)
            setting_data[:configured_keys].each do |configured_key|
                key_file_name = key_file.sub("#{node[:ssh][key_type][:file_path]}/", "")
                if key_file_name == configured_key
                    override[:ssh][key_type][:files] << configured_key
                    override[:ssh][:authorized_keys][:files] << key_file_content if key_type == :public_keys
                end
            end
        end
    end
end