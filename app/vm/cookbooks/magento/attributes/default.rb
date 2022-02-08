# Cookbook:: magento
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento][:options][:family] = MagentoHelper.define_family('Commerce')
default[:magento][:options][:minimum_stability] = 'stable'

default[:magento][:csc_options][:key_path] =
	'/var/chef/cache/cookbooks/magento/files/default'
default[:magento][:csc_options][:production_api_key] = ''
default[:magento][:csc_options][:project_id] = ''
default[:magento][:csc_options][:environment_id] = ''

default[:magento][:build][:action] = 'install'
default[:magento][:build][:modules_to_remove] = %w[
	magento/module-csp
	magento/module-cardinal-commerce
	magento/module-two-factor-auth
	allure-framework/allure-phpunit
]
default[:magento][:build][:community_consumer_list] = %w[
	product_action_attribute.update
	product_action_attribute.website.update
	codegeneratorProcessor
	exportProcessor
	media.storage.catalog.image.resize
	inventory.source.items.cleanup
	inventory.mass.update
	inventory.reservations.cleanup
	inventory.reservations.update
	inventory.reservations.updateSalabilityStatus
	inventory.indexer.sourceItem
	inventory.indexer.stock
	media.content.synchronization
	media.gallery.synchronization
	media.gallery.renditions.update
]
default[:magento][:build][:enterprise_consumer_list] = %w[
	negotiableQuotePriceUpdate
	sharedCatalogUpdatePrice
	sharedCatalogUpdateCategoryPermissions
	quoteItemCleaner
	inventoryQtyCounter
	purchaseorder.toorder
	purchaseorder.transactional.email
	purchaseorder.validation
	matchCustomerSegmentProcessor
]
default[:magento][:build][:sample_data][:module_list] = %w[
	magento/module-bundle-sample-data
	magento/module-catalog-rule-sample-data
	magento/module-catalog-sample-data
	magento/module-cms-sample-data
	magento/module-configurable-sample-data
	magento/module-customer-balance-sample-data
	magento/module-customer-sample-data
	magento/module-downloadable-sample-data
	magento/module-gift-card-sample-data
	magento/module-gift-registry-sample-data
	magento/module-grouped-product-sample-data
	magento/module-msrp-sample-data
	magento/module-multiple-wishlist-sample-data
	magento/module-offline-shipping-sample-data
	magento/module-product-links-sample-data
	magento/module-review-sample-data
	magento/module-sales-rule-sample-data
	magento/module-sales-sample-data
	magento/module-swatches-sample-data
	magento/module-target-rule-sample-data
	magento/module-tax-sample-data
	magento/module-theme-sample-data
	magento/module-widget-sample-data
	magento/module-wishlist-sample-data
	magento/sample-data-media
]
default[:magento][:build][:sample_data][:repository_url] =
	'https://github.com/magento/magento2-sample-data.git'
default[:magento][:build][:sample_data][:apply] = true
default[:magento][:build][:deploy_mode][:apply] = true
default[:magento][:build][:deploy_mode][:mode] = 'production'

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
default[:magento][:settings][:encryption_key] =
	'5fb338b139111ece4fd8d80fabc900b5'
