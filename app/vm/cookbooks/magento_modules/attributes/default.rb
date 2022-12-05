# Cookbook:: magento_modules
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento_modules][:required_module_list] = [
  { source: 'magento/extension-b2b' },
  { source: 'magento/ece-tools' },
  { source: 'magento/product-recommendations' },
  { source: 'magento/module-visual-product-recommendations' },
  { source: 'magento/live-search' },
]

default[:magento_modules][:modules_to_remove] = %w[
  magento/module-csp
  magento/module-cardinal-commerce
  magento/module-two-factor-auth
]

default[:magento_modules][:sample_data_module_list] = %w[
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
