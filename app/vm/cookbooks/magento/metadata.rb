name 'magento'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures Magento'
long_description 'Installs/Configures Magento'
version '0.1.0'
chef_version '>= 14.0'

depends 'init' # This brings in OS/Init configuration options
depends 'helpers' # This brings in helper libraries
depends 'php' # This brings in PHP configuration options
depends 'nginx' # This brings in the web root
depends 'mysql' # This brings in MySQL configuration options
depends 'search_engine' # This brings in Elasticsearch configuration options
depends 'samba' # This brings in Samba configuration options
depends 'composer' # This brings in Composer configuration options
depends 'magento_restore' # This brings in the ability to restore a Magento backup
depends 'magento_custom_modules' # This brings in Custom Module configuration options
depends 'magento_patches' # This brings in Magento Patches configuration options
depends 'magento_demo_builder' # This brings in the Demo Builder resource
depends 'vm_cli' # This brings in VM CLI commands

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/magento/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/magento'
