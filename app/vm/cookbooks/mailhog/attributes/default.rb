# Cookbook:: mailhog
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:mailhog][:mh_port] = '10000'
default[:mailhog][:smtp_port] = '1025'
default[:mailhog][:go_install_path] = '/root/go'
default[:mailhog][:install_path] = '/usr/local/bin'
default[:mailhog][:service_file] = '/etc/systemd/system/mailhog.service'
default[:mailhog][:sendmail_path] = '/usr/local/bin/mhsendmail'
default[:mailhog][:repositories] = [
	{ url: 'github.com/mailhog/MailHog', name: 'MailHog' },
	{ url: 'github.com/mailhog/mhsendmail', name: 'mhsendmail' },
]
