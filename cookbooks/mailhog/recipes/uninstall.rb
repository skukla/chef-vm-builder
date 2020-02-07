#
# Cookbook:: mailhog
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
repositories = node[:infrastructure][:mailhog][:repositories]

# Stop mailhog in case its running
service 'mailhog' do
    action :stop
end

# Uninstall mailhog
repositories.each do |repository|
    execute "Uninstall #{repository[:name]}" do
        command "sudo rm -rf /usr/local/bin/#{repository[:name].downcase}"
    end
end
