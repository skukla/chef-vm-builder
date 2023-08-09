# Cookbook:: magento
# Attribute:: default_build_options
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento][:build][:action] = 'install'
default[:magento][:build][:sample_data][:apply] = true
default[:magento][:build][:deploy_mode][:apply] = true
default[:magento][:build][:deploy_mode][:mode] = 'production'

default[:magento][:build][:hooks][:warm_cache] = false
default[:magento][:build][:hooks][:backup] = false
default[:magento][:build][:hooks][:sync_media_gallery] = false

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
