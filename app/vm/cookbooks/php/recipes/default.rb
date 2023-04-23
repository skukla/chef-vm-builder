# Cookbook:: php
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

php 'Uninstall any old php installations' do
  action %i[stop uninstall]
  only_if { ::Dir.exist?('/etc/php') }
end

php 'Install, configure, enable, and start PHP' do
  action %i[install configure enable restart]
end

php 'Remove Apache packages' do
  action :remove_apache_packages
end
