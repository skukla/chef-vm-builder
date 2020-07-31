#
# Cookbook:: apache
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:apache][:package_list]= ["apache2", "apache2-bin", "apache2-data", "apache2-utils"]
default[:apache][:mod_list] = ["rewrite", "ssl", "actions", "proxy_fcgi"]
default[:apache][:ssl_passphrase_dialog] = "builtin"
default[:apache][:http_port] = 80