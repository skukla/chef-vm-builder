#
# Cookbook:: php
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
version = node[:php][:version]

# Add PHP repository
apt_repository "php-#{version}" do
    uri 'ppa:ondrej/php'
    components ['main']
    distribution "bionic"
    action :add
    retries 3
    not_if { ::File.exist?("/etc/apt/sources.list.d/php-#{version}.list") }
end

# Install specified PHP and extensions
# Use string replacement to inject the PHP version, then install the package
extension_list = Array.new
node[:php][:extension_list].each do |raw_extension|
    extension = format(raw_extension, {version: version})
    apt_package extension do
        action :install
    end
end

# Remove any package left-overs
execute "Remove package leftovers" do
    command 'sudo apt-get autoremove -y'
end