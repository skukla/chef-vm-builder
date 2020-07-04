name 'magento_configuration'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures application configuration'
long_description 'Installs/Configures application configuration'
version '0.1.0'
chef_version '>= 14.0'

depends 'init'              # This brings in OS settings
depends 'helpers'           # This brings in helper libraries
depends 'composer'          # This brings in composer settings
depends 'samba'             # This brings in samba settings
depends 'elasticsearch'     # This brings in elasticsearch settings
depends 'magento'           # This brings in Magento settings


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
