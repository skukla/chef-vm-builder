# Cookbook:: php
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:php][:version] = '7.4'
default[:php][:user] = 'www-data'
default[:php][:port] = 9000
default[:php][:memory_limit] = '3G'
default[:php][:upload_max_filesize] = '2M'
default[:php][:extension_list] = [
  'php%<version>s',
  'php%<version>s-common',
  'php%<version>s-gd',
  'php%<version>s-mysql',
  'php%<version>s-curl',
  'php%<version>s-intl',
  'php%<version>s-xsl',
  'php%<version>s-mbstring',
  'php%<version>s-zip',
  'php%<version>s-bcmath',
  'php%<version>s-iconv',
  'php%<version>s-soap',
  'php%<version>s-fpm'
]
default[:php][:max_execution_time] = 1800
default[:php][:zlib_output_compression] = 'On'
default[:php][:backend] = '127.0.0.1'
default[:php][:apache_package_list] = %w[apache2 apache2-bin apache2-data apache2-utils]