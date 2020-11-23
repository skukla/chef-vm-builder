#
# Cookbook:: mailhog
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_mailhog = node[:mailhog][:use]
sendmail_path = if use_mailhog
                  node[:mailhog][:sendmail_path]
                else
                  ''
                end

golang 'Uninstall golang' do
  action :uninstall
  only_if { !use_mailhog }
end

golang 'Install golang' do
  action :install
  only_if { use_mailhog }
end

mailhog 'Stop and uninstall mailhog' do
  action %i[stop uninstall]
  only_if { !use_mailhog }
end

mailhog 'Install, configure, enable, reload, and stop mailhog' do
  action %i[install configure enable reload stop]
  only_if { use_mailhog }
end

php 'Configure mailhog sendmail path and restart PHP' do
  action %i[configure_sendmail restart]
  sendmail_path sendmail_path
end
