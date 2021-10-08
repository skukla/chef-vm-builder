#
# Cookbook:: nginx
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
nginx 'Install Nginx' do
	action :install
end

nginx 'Create download directories and clear existing sites' do
	action %i[create_tmp_dir create_web_root clear_sites]
end
