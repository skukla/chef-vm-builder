#
# Cookbook:: php
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
fpm_port = node[:infrastructure][:php][:fpm_port]
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
version = node[:infrastructure][:php][:version]
timezone = node[:infrastructure][:php][:timezone]
memory_limit = node[:infrastructure][:php][:memory_limit]
upload_max_filesize = node[:infrastructure][:php][:upload_max_filesize]
max_execution_time = node[:infrastructure][:php][:ini_options][:max_execution_time]
zlib_output_compression = node[:infrastructure][:php][:ini_options][:zlib_output_compression]
fpm_backend = node[:infrastructure][:php][:fpm_options][:backend]

# Configure php.ini and php-fpm
['cli', 'fpm'].each do |type|
    template "#{type}" do
        source 'php.ini.erb'
        path "/etc/php/#{version}/#{type}/php.ini"
        owner 'root'
        group 'root'
        mode '644'
        variables({
            timezone: "#{timezone}",
            memory_limit: "#{memory_limit}",
            upload_max_filesize: "#{upload_max_filesize}",
            max_execution_time: "#{max_execution_time}",
            zlib_output_compression: "#{zlib_output_compression}"
        })
    end
    if type == 'fpm'
        template "#{type}" do
            source 'www.conf.erb'
            path "/etc/php/#{version}/#{type}/pool.d/www.conf"
            owner 'root'
            group 'root'
            mode '644'
            variables({
                owner: "#{user}",
                user: "#{user}",
                group: "#{group}",
                backend: "#{fpm_backend}",
                port: "#{fpm_port}"
            })
        end
    end
end

# Start the fpm service for the desired version
service "php#{version}-fpm" do
    action [:enable, :start]
end