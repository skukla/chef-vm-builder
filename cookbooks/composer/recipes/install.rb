#
# Cookbook:: composer
# Recipe:: install
#
# Copyright:: 2020, Steve, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
composer_install_dir = node[:composer][:install_dir]
composer_file = node[:composer][:filename]

# Download composer and run install script
execute 'Download and install Composer' do
  command "curl -sS https://getcomposer.org/installer | php && mv #{composer_file}.phar /#{composer_install_dir}/#{composer_file} && chmod +x /#{composer_install_dir}/#{composer_file}"
  action :run
  not_if { File.exist?("/#{composer_install_dir}/#{composer_file}") }
end

# Make composer accessible globally
link "/home/#{user}/#{composer_file}" do
  to "/usr/local/bin/#{composer_file}"
end

link "/home/#{user}/#{composer_file}.phar" do
  to "/#{composer_install_dir}/#{composer_file}"
end

# Make sure composer is up to date
execute 'Composer Update' do
  command "#{composer_file} self-update"
  action :run
end
