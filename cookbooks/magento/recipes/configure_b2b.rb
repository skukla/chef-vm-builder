#
# Cookbook:: magento
# Recipe:: configure_b2b
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
web_root = node[:application][:webserver][:web_root]

# Start B2B consumers
b2b_consumers = [
    'negotiableQuotePriceUpdate', 
    'sharedCatalogUpdatePrice', 
    'sharedCatalogUpdateCategoryPermissions', 
    'quoteItemCleaner'
]
consumers_string = b2b_consumers.join(' ')
execute "Start B2B Consumers" do
    command "cd #{web_root} && bin/magento queue:consumers:start #{consumers_string} &"
end
