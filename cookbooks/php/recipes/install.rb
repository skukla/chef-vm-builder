#
# Cookbook:: php
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
supported_versions = node[:infrastructure][:php][:supported_versions]
version = node[:infrastructure][:php][:version]

# Add PHP repository
apt_repository "php-#{version}" do
    uri 'ppa:ondrej/php'
    components ['main']
    distribution "bionic"
    action :add
    retries 3
    not_if { ::File.exist?("/etc/apt/sources.list.d/php-#{version}.list") }
end

# Install specified supported PHP and extensions
# Use string replacement to inject the PHP version, then install the package
supported_versions.each do |supported_version|
    extension_list = Array.new
    node[:infrastructure][:php][:extension_list].each do |raw_extension|
        extension = format(raw_extension, {version: supported_version})
        apt_package extension do
            action :install
        end
    end
end

# Remove any package left-overs
execute "Remove package leftovers" do
    command 'sudo apt-get autoremove -y'
end