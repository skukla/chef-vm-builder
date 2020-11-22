#
# Cookbook:: php
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
php 'Set PHP user, then install, configure, enable, and start PHP' do
  action %i[set_user install configure enable restart]
end

php 'Remove Apache packages' do
  action :remove_apache_packages
end
