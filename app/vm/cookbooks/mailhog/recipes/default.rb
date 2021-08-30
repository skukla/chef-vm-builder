#
# Cookbook:: mailhog
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
sendmail_path = node[:mailhog][:sendmail_path]

golang 'Install golang' do
	action :install
end

mailhog 'Stop, uninstall, configure, enable, reload, and stop mailhog' do
	action %i[install configure enable reload stop]
end

php 'Configure mailhog sendmail path and restart PHP' do
	action %i[configure_sendmail restart]
	sendmail_path sendmail_path
end
