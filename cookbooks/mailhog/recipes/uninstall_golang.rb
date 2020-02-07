#
# Cookbook:: mailhog
# Recipe:: uninstall_golang
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes

# Stop mailhog in case its running
service 'mailhog' do
    action :stop
end
# Uninstall golang
apt_package 'golang-go' do
    action [:remove, :purge]
end
# execute "Uninstall Golang" do
#     command "sudo apt-get remove golang-go -y && sudo apt-get purge --auto-remove golang-go* -y && rm -rf /usr/local/go/ && rm -rf /root/go"
#     only_if { ::File.directory?("/root/go") }
# end
