#
# Cookbook:: mailhog
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:infrastructure][:mailhog][:repositories] = [
    {
        url: 'github.com/mailhog/MailHog',
        name: 'MailHog'
    },
    {
        url: 'github.com/mailhog/mhsendmail',
        name: 'mhsendmail'
    }
]
