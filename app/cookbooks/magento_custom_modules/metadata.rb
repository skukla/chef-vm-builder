name 'magento_custom_modules'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures Magento custom modules'
long_description 'Installs/Configures Magento custom modules'
version '0.1.0'
chef_version '>= 14.0'

depends 'init'                      # Brings in OS settings
depends 'helpers'                   # Brings in helper libraries
depends 'composer'                  # Brings in Composer settings
depends 'magento'                   # Brings in the magento resources

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/init/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/init'
