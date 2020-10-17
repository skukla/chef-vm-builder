#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento][:installation][:options][:family] = "community"
default[:magento][:installation][:options][:version] = "2.4.0"
default[:magento][:installation][:options][:minimum_stability] = "stable"
default[:magento][:installation][:options][:community_consumer_list] = [
    "product_action_attribute.update",
    "product_action_attribute.website.update",
    "codegeneratorProcessor",
    "exportProcessor",
    "media.storage.catalog.image.resize",
    "inventory.source.items.cleanup",
    "inventory.mass.update",
    "inventory.reservations.cleanup",
    "inventory.reservations.update",
    "inventory.reservations.updateSalabilityStatus",
    "inventory.indexer.sourceItem",
    "inventory.indexer.stock",
    "media.content.synchronization",
    "media.gallery.synchronization"
]
default[:magento][:installation][:options][:enterprise_consumer_list] = [
    "negotiableQuotePriceUpdate",
    "sharedCatalogUpdatePrice",
    "sharedCatalogUpdateCategoryPermissions",
    "quoteItemCleaner",
    "inventoryQtyCounter",
    "purchaseorder.toorder",
    "purchaseorder.transactional.email",
    "purchaseorder.validation"
]
consumer_list = Array.new
node[:magento][:installation][:options][:community_consumer_list].each do |consumer|
    consumer_list << consumer
end
unless node[:magento][:installation][:options][:enterprise_consumer_list].empty?
    node[:magento][:installation][:options][:enterprise_consumer_list].each do |consumer|
        consumer_list << consumer
    end
end
default[:magento][:installation][:options][:consumer_list] = consumer_list
default[:magento][:installation][:build][:action] = "install"
default[:magento][:installation][:build][:modules_to_remove] = [
    "magento/module-csp", 
    "magento/module-cardinal-commerce", 
    "magento/module-two-factor-auth"
]
default[:magento][:installation][:build][:sample_data] = true
default[:magento][:installation][:build][:deploy_mode][:apply] = true
default[:magento][:installation][:build][:deploy_mode][:mode] = "production"

default[:magento][:installation][:build][:hooks][:warm_cache] = false
default[:magento][:installation][:build][:hooks][:enable_media_gallery] = false
default[:magento][:installation][:build][:hooks][:commands] = []

default[:magento][:installation][:settings][:backend_frontname] = "admin"
default[:magento][:installation][:settings][:unsecure_base_url] = "http://#{node[:fqdn]}/"
default[:magento][:installation][:settings][:secure_base_url] = "https://#{node[:fqdn]}/"
default[:magento][:installation][:settings][:language] = "en_US"
default[:magento][:installation][:settings][:currency] = "USD"
default[:magento][:installation][:settings][:admin_firstname] = "Admin"
default[:magento][:installation][:settings][:admin_lastname] = "Admin"
default[:magento][:installation][:settings][:admin_email] = "admin@#{node[:fqdn]}"
default[:magento][:installation][:settings][:admin_user] = "admin"
default[:magento][:installation][:settings][:admin_password] = "admin123"
default[:magento][:installation][:settings][:use_rewrites] = 1
default[:magento][:installation][:settings][:use_secure_frontend] = 0
default[:magento][:installation][:settings][:use_secure_admin] = 0
default[:magento][:installation][:settings][:cleanup_database] = 1
default[:magento][:installation][:settings][:session_save] = "db"
default[:magento][:installation][:settings][:encryption_key] = "5fb338b139111ece4fd8d80fabc900b5"