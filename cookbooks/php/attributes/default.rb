#
# Cookbook:: php
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:infrastructure][:php] = {
    repository: 'ondrej/php',
    supported_versions: ['7.2', '7.3','7.4'],
    extension_list: [
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
    ],
    ini_options: {
        timezone: 'America/Los_Angeles',
        memory_limit: '2G',
        max_execution_time: 1800,
        zlib_output_compression: 'On'
    }
}

