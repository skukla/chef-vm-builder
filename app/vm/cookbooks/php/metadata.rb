name 'php'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures php'
long_description 'Installs/Configures php'
version '0.1.0'
chef_version '>= 14.0'

depends 'init'           # For user and timezone
depends 'nginx'          # For web root
depends 'helpers'        # Brings in string replace helper
depends 'mailhog'        # Brings in mailhog's sendmail path

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/php/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/php'
