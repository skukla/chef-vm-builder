#
# Cookbook:: mailhog
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:mailhog][:use] = true
default[:mailhog][:port] = 10000
default[:mailhog][:smtp_port] = 1025
default[:mailhog][:sendmail_path] = "/usr/local/bin/mhsendmail"
default[:mailhog][:repositories] = [
    {url: "github.com/mailhog/MailHog", name: "MailHog" },
    {url: "github.com/mailhog/mhsendmail", name: "mhsendmail" }
]
