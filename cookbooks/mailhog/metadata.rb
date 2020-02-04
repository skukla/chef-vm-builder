name 'mailhog'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures mailhog'
long_description 'Installs/Configures mailhog'
version '0.1.0'
chef_version '>= 14.0'

depends 'init'  # This brings in VM user/group
depends 'php'   # This brings in the fpm service to be restarted when sendmail is configured

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/mailhog/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/mailhog'
