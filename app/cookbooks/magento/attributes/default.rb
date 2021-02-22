#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento][:options][:family] = 'community'
default[:magento][:options][:version] = '2.4.0'
default[:magento][:options][:minimum_stability] = 'stable'
default[:magento][:options][:community_consumer_list] = [
  'product_action_attribute.update',
  'product_action_attribute.website.update',
  'codegeneratorProcessor',
  'exportProcessor',
  'media.storage.catalog.image.resize',
  'inventory.source.items.cleanup',
  'inventory.mass.update',
  'inventory.reservations.cleanup',
  'inventory.reservations.update',
  'inventory.reservations.updateSalabilityStatus',
  'inventory.indexer.sourceItem',
  'inventory.indexer.stock',
  'media.content.synchronization',
  'media.gallery.synchronization'
]

default[:magento][:options][:enterprise_consumer_list] = [
  'negotiableQuotePriceUpdate',
  'sharedCatalogUpdatePrice',
  'sharedCatalogUpdateCategoryPermissions',
  'quoteItemCleaner',
  'inventoryQtyCounter',
  'purchaseorder.toorder',
  'purchaseorder.transactional.email',
  'purchaseorder.validation',
  'matchCustomerSegmentProcessor'
]
consumer_list = []
node[:magento][:options][:community_consumer_list].each do |consumer|
  consumer_list << consumer
end
unless node[:magento][:options][:enterprise_consumer_list].empty?
  node[:magento][:options][:enterprise_consumer_list].each do |consumer|
    consumer_list << consumer
  end
end
default[:magento][:options][:consumer_list] = consumer_list

default[:magento][:build][:action] = 'install'
default[:magento][:build][:modules_to_remove] = [
  'magento/module-csp',
  'magento/module-cardinal-commerce',
  'magento/module-two-factor-auth'
]
default[:magento][:build][:sample_data] = true
default[:magento][:build][:deploy_mode][:apply] = true
default[:magento][:build][:deploy_mode][:mode] = 'production'

default[:magento][:build][:hooks][:warm_cache] = false
default[:magento][:build][:hooks][:enable_media_gallery] = false
default[:magento][:build][:hooks][:commands] = []

default[:magento][:settings][:backend_frontname] = 'admin'
default[:magento][:settings][:unsecure_base_url] = "http://#{node[:fqdn]}/"
default[:magento][:settings][:secure_base_url] = "https://#{node[:fqdn]}/"
default[:magento][:settings][:language] = 'en_US'
default[:magento][:settings][:currency] = 'USD'
default[:magento][:settings][:admin_firstname] = 'Admin'
default[:magento][:settings][:admin_lastname] = 'Admin'
default[:magento][:settings][:admin_email] = "admin@#{node[:fqdn]}"
default[:magento][:settings][:admin_user] = 'admin'
default[:magento][:settings][:admin_password] = 'admin123'
default[:magento][:settings][:use_rewrites] = 1
default[:magento][:settings][:use_secure_frontend] = 0
default[:magento][:settings][:use_secure_admin] = 0
default[:magento][:settings][:cleanup_database] = 1
default[:magento][:settings][:session_save] = 'db'
default[:magento][:settings][:encryption_key] = '5fb338b139111ece4fd8d80fabc900b5'
