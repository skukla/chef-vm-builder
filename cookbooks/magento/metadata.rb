name 'magento'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures magento'
long_description 'Installs/Configures magento'
version '0.1.0'
chef_version '>= 14.0'

depends 'init'              # This brings in OS/Init configuration options
depends 'helpers'           # This brings in helper libraries
depends 'php'               # This brings in PHP configuration options
depends 'nginx'             # This brings in Nginx configuration options
depends 'mysql'             # This brings in MySQL configuration options
depends 'elasticsearch'     # This brings in Elasticsearch configuration options
depends 'webmin'            # This brings in Webmin configuration options
depends 'samba'             # This brings in Samba configuration options
depends 'composer'          # This brings in Composer configuration options
depends 'custom_modules'    # This brings in Custom Module configuration options
depends 'app_patches'       # This brings in App Patches configuration options
depends 'app_configuration' # This brings in App Configuration configuration options

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
