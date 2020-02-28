#
# Cookbook:: composer
# Recipe:: install
#
# Copyright:: 2020, Steve, All Rights Reserved.

# Attributes
user = node[:infrastructure][:composer][:user]
group = node[:infrastructure][:composer][:group]
install_dir = node[:infrastructure][:composer][:install_dir]
filename = node[:infrastructure][:composer][:filename]

# Download composer and run install script
execute 'Download and install Composer' do
  command "curl -sS https://getcomposer.org/installer | php && mv #{filename}.phar /#{install_dir}/#{filename} && chmod +x /#{install_dir}/#{filename}"
  action :run
  not_if { File.exist?("/#{install_dir}/#{filename}") }
end

# Make sure composer is up to date
execute 'Composer Update' do
  command "/#{install_dir}/#{filename} self-update"
  action :run
end

# Make composer accessible globally
link "/home/#{user}/#{filename}" do
  to "/usr/local/bin/composer"
end

link "/home/#{user}/#{filename}.phar" do
  to "/#{install_dir}/#{filename}"
end
