#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:application][:verticals][:fashion][:us_en][:b2b] = {
    scope: 'website',
    code: 'luma_b2b',
    url: 'b2b.luma.com'
}
default[:application][:verticals][:fashion][:us_en][:b2c] = {
    scope: 'website',
    code: 'base',
    url: 'luma.com'
}
default[:application][:verticals][:custom][:us_en][:b2b] = {
    scope: 'website',
    code: 'custom_b2b',
    url: 'b2b.custom-demo.com'
}
default[:application][:verticals][:custom][:us_en][:b2c] = {
    scope: 'website',
    code: 'custom_b2c',
    url: 'custom-demo.com'
}
