name 'app_controller'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Controls the VM Builder application flow'
long_description 'Controls the VM Builder application flow'
version '0.1.0'
chef_version '>= 14.0'

depends 'init' # Brings in web root and build action
depends 'ssl' # Brings in ssl usage
depends 'nginx' # Brings in the web root
depends 'mailhog' # Brings in mailhog usage
depends 'magento' # Brings in Magento usage
depends 'magento_demo_builder' # Brings in Magento Demo Builder usage
depends 'magento_restore' # Brings in the backup holding area

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
