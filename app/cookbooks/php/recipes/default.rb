#
# Cookbook:: php
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
extension_list = node[:php][:extension_list]
configuration = {
    port: node[:php][:port],
    memory_limit: node[:php][:memory_limit],
    upload_max_filesize: node[:php][:upload_max_filesize],
    timezone: node[:php][:timezone],
    backend: node[:php][:backend],
    max_execution_time: node[:php][:max_execution_time],
    zlib_output_compression: node[:php][:zlib_output_compression]
}

php "Set PHP user, then install, configure, enable, and start PHP" do
    action [:set_user, :install, :configure, :enable, :restart]
    php_user "www-data"
    extension_list extension_list
    configuration configuration
end
