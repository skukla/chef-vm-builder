#
# Cookbook:: apache
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:apache][:package_list]= ["apache2", "apache2-bin", "apache2-data", "apache2-utils"]
default[:apache][:mod_list] = ["rewrite", "ssl", "actions", "proxy_fcgi"]
default[:apache][:directory_list] = ["/etc/apache2", "/var/lib/apache2/fastcgi", "/var/lock/apache2", "/var/log/apache2"]
default[:apache][:http_port] = 80