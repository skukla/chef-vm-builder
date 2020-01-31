#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:application][:verticals][:fashion][:us_en][:b2b] = {
    code: 'luma_b2b',
    url: 'b2b.luma.com'
}
default[:application][:verticals][:fashion][:us_en][:b2c] = {
    code: 'base',
    url: 'luma.com'
}
default[:application][:verticals][:custom][:us_en][:b2b] = {
    code: 'custom_b2b',
    url: 'b2b.custom-demo.com'
}
default[:application][:verticals][:custom][:us_en][:b2c] = {
    code: 'custom_b2c',
    url: 'custom-demo.com'
}
