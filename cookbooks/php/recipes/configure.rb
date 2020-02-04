#
# Cookbook:: php
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
supported_versions = node[:infrastructure][:php][:supported_versions]
version = node[:infrastructure][:php][:version]
ini_options = node[:infrastructure][:php][:ini_options]
fpm_options = node[:infrastructure][:php][:fpm_options]

# Configure php.ini and php-fpm
supported_versions.each do |suppported_version|
    ['cli', 'fpm'].each do |type|
        template "#{type}" do
            source 'php.ini.erb'
            path "/etc/php/#{suppported_version}/#{type}/php.ini"
            owner 'root'
            group 'root'
            mode '644'
            variables({
                timezone: ini_options[:timezone],
                memory_limit: ini_options[:memory_limit],
                max_execution_time: ini_options[:max_execution_time],
                zlib_output_compression: ini_options[:zlib_output_compression]
            })
        end
        if type == 'fpm'
            template "#{type}" do
                source 'www.conf.erb'
                path "/etc/php/#{suppported_version}/#{type}/pool.d/www.conf"
                owner 'root'
                group 'root'
                mode '644'
                variables({
                    owner: fpm_options[:owner],
                    user: fpm_options[:user],
                    group: fpm_options[:group],
                    backend: fpm_options[:backend],
                    port: fpm_options[:port]
                })
            end
        end
    end
end

# Set the desired version
['php', 'phar', 'phar.phar'].each do |item|
    execute "Set PHP Item: #{item}" do
        command "sudo update-alternatives --set #{item}  /usr/bin/#{item}#{version}"
    end
end

# Start the fpm service for the desired version
service "php#{version}-fpm" do
    action [:enable, :start]
end
