name 'magento_demo_builder'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures custom demo data'
long_description 'Installs/Configures custom demo data'
version '0.1.0'
chef_version '>= 14.0'

depends 'helpers' # Brings in the various helpers
depends 'nginx' # Brings in web root
depends 'magento' # Brings in Magento settings
depends 'magento_patches' # Brings in Magento patch settings
depends 'magento_restore' # Brings in Magento restore settings

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/composer/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/composer'
