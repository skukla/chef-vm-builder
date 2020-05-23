#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe "nginx::create_web_root"
include_recipe "nginx::configure_multisite"
include_recipe "mysql::start"
include_recipe "elasticsearch::start"
include_recipe "magento::uninstall"
include_recipe "magento::download"
include_recipe "magento::install"
include_recipe "magento::configure"
include_recipe "magento::wrap_up"

# Note: Nginx, Mailhog, Webmin, and Samba are started via the the application role