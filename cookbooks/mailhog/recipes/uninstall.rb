#
# Cookbook:: mailhog
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
repositories = node[:infrastructure][:mailhog][:repositories]

# Stop mailhog in case its running and reload the daemon
service 'mailhog' do
    action :stop
end

# Uninstall mailhog
repositories.each do |repository|
    execute "Uninstall #{repository[:name]}" do
        command "sudo rm -rf /usr/local/bin/#{repository[:name].downcase}"
    end
end

# Uninstall golang
execute "Uninstall golang" do
    command "sudo apt-get remove golang-go -y && sudo apt-get purge --auto-remove golang-go* -y && rm -rf /usr/local/go/ && rm -rf /root/go"
    only_if { ::File.directory?("/root/go") }
end
