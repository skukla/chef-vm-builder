name 'magento_patches'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures application patches'
long_description 'Installs/Configures application patches'
version '0.1.0'
chef_version '>= 14.0'

depends 'init' # Brings in init attributes
depends 'nginx' # Brings in web root
depends 'helpers' # Brings in the build_patch_file helper
depends 'composer' # Brings in composer attributes
depends 'magento' # Brings in Magento resources
depends 'magento_demo_builder' # Brings in patch files from demo builder

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
