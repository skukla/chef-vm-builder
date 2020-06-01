#
# Cookbook:: webmin
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
apt_repository "webmin" do
    uri "http://download.webmin.com/download/repository"
    distribution "sarge"
    components ["contrib"]
    key "http://www.webmin.com/jcameron-key.asc"
    action :add
    retries 3
    ignore_failure true
    not_if { ::File.exist?('/etc/apt/sources.list.d/webmin.list') }
end

# Stop mailhog in case its running (since Mailhog and Webmin share a default port)
# Webmin's port gets set as part of its install script which sucks
service 'mailhog' do
    action :stop
end

# Install webmin
apt_package "webmin" do
    action :install
end
