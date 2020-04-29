#
# Cookbook:: mailhog
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
php_version = node[:mailhog][:php_version]
port = node[:mailhog][:port]
smtp_port = node[:mailhog][:smtp_port]

# Configure the mailhog service
template 'Mailhog service' do
    source 'mailhog.service.erb'
    path '/etc/systemd/system/mailhog.service'
    owner 'root'
    group 'root'
    mode '0644'
    variables({ 
        port: "#{port}",
        smtp_port: "#{smtp_port}"
    })
end

# Configure sendmail in php.ini for all php versions
['cli', 'fpm'].each do |type| 
    ruby_block "Configure sendmail in php-#{php_version}.ini" do
        block do
            file = Chef::Util::FileEdit.new("/etc/php/#{php_version}/#{type}/php.ini")
            file.insert_line_if_no_match(/^sendmail_path =/, '/usr/local/bin/mhsendmail')
            file.search_file_replace_line(/^sendmail_path =/, 'sendmail_path = /usr/local/bin/mhsendmail')
            file.write_file
        end
    only_if { ::File.exists?("/etc/php/#{php_version}/#{type}/php.ini") }
    notifies :restart, "service[php#{php_version}-fpm]", :immediately
    end
end

service 'mailhog' do
    action :enable
end

# Reload the mailhog daemon
execute "Reload all daemons" do
    command "sudo systemctl daemon-reload"
end
