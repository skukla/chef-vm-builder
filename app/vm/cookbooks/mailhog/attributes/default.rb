# Cookbook:: mailhog
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:mailhog][:mh_port] = '10000'
default[:mailhog][:smtp_port] = '1025'
default[:mailhog][:go_install_path] = '/root/go'
default[:mailhog][:install_path] = '/usr/local/bin'
default[:mailhog][:systemd_template_path] = 'mailhog.service.erb'
default[:mailhog][:systemd_service_file] = '/etc/systemd/system/mailhog.service'
default[:mailhog][:init_d_service_file] = '/etc/init.d/mailhog'
default[:mailhog][:init_d_template_path] = 'mailhog.init.d.erb'
default[:mailhog][:sendmail_path] = '/usr/local/bin/mhsendmail'
default[:mailhog][:repositories] = [
  { url: 'github.com/mailhog/MailHog', name: 'MailHog' },
  { url: 'github.com/mailhog/mhsendmail', name: 'mhsendmail' },
]
