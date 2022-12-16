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
  { source: 'git@github.com:PMET-public/FireGento_FastSimpleImport2.git' },
  { source: 'git@github.com:PMET-public/module-data-install.git' },
  { source: 'git@github.com:PMET-public/module-data-install-graphql.git' },
  { source: 'git@github.com:PMET-public/module-saas-data-management.git' },
]

default[:magento_modules][:modules_to_remove] = [
  { source: 'magento/module-csp' },
  { source: 'magento/module-cardinal-commerce' },
  { source: 'magento/module-two-factor-auth' },
]

default[:magento_modules][:sample_data_module_list] = [
  { source: 'magento/module-bundle-sample-data' },
  { source: 'magento/module-catalog-rule-sample-data' },
  { source: 'magento/module-catalog-sample-data' },
  { source: 'magento/module-cms-sample-data' },
  { source: 'magento/module-configurable-sample-data' },
  { source: 'magento/module-customer-balance-sample-data' },
  { source: 'magento/module-customer-sample-data' },
  { source: 'magento/module-downloadable-sample-data' },
  { source: 'magento/module-gift-card-sample-data' },
  { source: 'magento/module-gift-registry-sample-data' },
  { source: 'magento/module-grouped-product-sample-data' },
  { source: 'magento/module-msrp-sample-data' },
  { source: 'magento/module-multiple-wishlist-sample-data' },
  { source: 'magento/module-offline-shipping-sample-data' },
  { source: 'magento/module-product-links-sample-data' },
  { source: 'magento/module-review-sample-data' },
  { source: 'magento/module-sales-rule-sample-data' },
  { source: 'magento/module-sales-sample-data' },
  { source: 'magento/module-swatches-sample-data' },
  { source: 'magento/module-target-rule-sample-data' },
  { source: 'magento/module-tax-sample-data' },
  { source: 'magento/module-theme-sample-data' },
  { source: 'magento/module-widget-sample-data' },
  { source: 'magento/module-wishlist-sample-data' },
  { source: 'magento/sample-data-media' },
]
