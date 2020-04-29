#
# Cookbook:: php
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:php][:version] = "7.3"
default[:php][:port] = 9000
default[:php][:memory_limit] = "2G"
default[:php][:upload_max_filesize] = "2M"
default[:php][:extension_list] = [
    "php%{version}",
    "php%{version}-common",
    "php%{version}-gd",
    "php%{version}-mysql",
    "php%{version}-curl",
    "php%{version}-intl",
    "php%{version}-xsl",
    "php%{version}-mbstring",
    "php%{version}-zip",
    "php%{version}-bcmath",
    "php%{version}-iconv",
    "php%{version}-soap",
    "php%{version}-fpm"
]
default[:php][:max_execution_time] = 1800
default[:php][:zlib_output_compression] = "On"
default[:php][:backend] = "127.0.0.1"
default[:php][:apache_packages] = [
    "apache2", 
    "apache2-bin", 
    "apache2-data", 
    "apache2-utils"
]



