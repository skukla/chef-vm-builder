#
# Cookbook:: php
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:infrastructure][:php][:supported_versions] = [
    '7.3'
]
default[:infrastructure][:php][:extension_list] = [
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
default[:infrastructure][:php][:ini_options] = {
    max_execution_time: 1800,
    zlib_output_compression: 'On'
}
default[:infrastructure][:php][:fpm_options][:backend] = '127.0.0.1'
default[:infrastructure][:php][:apache_packages] = [
    "apache2", 
    "apache2-bin", 
    "apache2-data", 
    "apache2-utils"
]



