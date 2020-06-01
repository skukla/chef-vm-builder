name 'magento_internal'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Magento Internal-team-specific features'
long_description 'Contains internal team patching logic and custom module proxy'
version '0.1.0'
chef_version '>= 14.0'

depends 'init'                  # This brings in Init attributes
depends 'magento'               # This brings in Magento attributes
depends 'magento_patches'       # This brings in Magento Patches attributes

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
