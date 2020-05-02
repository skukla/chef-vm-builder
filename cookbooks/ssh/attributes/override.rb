#
# Cookbook:: ssh
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = [:private_key_files, :public_key_files]
key_path = "/var/chef/cache/cookbooks/ssh/files/keys"
private_key_files = Dir["#{key_path}/private/*"]
public_key_files = Dir["#{key_path}/public/*"]
override[:ssh][:authorized_keys] = Array.new

if node[:application][:authentication][:ssh].is_a? Chef::Node::ImmutableMash
    supported_settings.each do |setting_value|
        key_type = setting_value.to_s.sub("_key_files", "")
        next if node[:application][:authentication][:ssh][setting_value].nil? 
        if setting_value == :private_key_files
            key_check = "PRIVATE KEY"
        elsif setting_value == :public_key_files
            key_check = "ssh-rsa"
        end
        Dir["#{key_path}/#{key_type}/*"].each do |key_file|
            key_content = File.readlines("#{key_file}")[0]
            if key_content.include?(key_check)
                override[:ssh][setting_value] = Dir["#{key_path}/#{key_type}/*"].map { |key_file| key_file.sub("#{key_path}/#{key_type}/", "") } & node[:application][:authentication][:ssh][setting_value]
                if setting_value == :public_key_files
                    override[:ssh][:authorized_keys] << node[:ssh][:vagrant_insecure_key]
                    override[:ssh][:authorized_keys] << key_content
                end
            end
        end
    end
end