name 'nginx'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures nginx'
long_description 'Installs/Configures nginx'
version '0.1.0'
chef_version '>= 14.0'

depends 'init'      # This brings in VM user/group
depends 'php'       # This brings in PHP FPM options
depends 'magento'   # This brings in Magento website information

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/nginx/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/nginx'
