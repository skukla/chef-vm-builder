name 'init'
maintainer 'Steve Kukla'
maintainer_email 'kukla@adobe.com'
license 'All Rights Reserved'
description 'Installs/Configures the OS and initial settings'
long_description 'Installs/Configures the OS and initial settings'
version '0.1.0'
chef_version '>= 14.0'

depends 'nginx'     # Brings in multisite settings
depends 'mailhog'   # Brings in mailhog usage
depends 'webmin'    # Brings in webmin usage

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