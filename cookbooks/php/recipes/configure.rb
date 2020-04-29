#
# Cookbook:: php
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
port = node[:infrastructure][:php][:port]
version = node[:infrastructure][:php][:version]
memory_limit = node[:infrastructure][:php][:memory_limit]
upload_max_filesize = node[:infrastructure][:php][:upload_max_filesize]
timezone = node[:infrastructure][:php][:timezone]
backend = node[:php][:backend]
max_execution_time = node[:php][:max_execution_time]
zlib_output_compression = node[:php][:zlib_output_compression]

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
                backend: "#{backend}",
                port: "#{port}"
            })
        end
    end
end

# Start the fpm service for the desired version
service "php#{version}-fpm" do
    action [:enable, :start]
end