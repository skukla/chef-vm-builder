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
execute 'Download Composer' do
  command "curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=#{install_dir} --filename=#{filename}"
  not_if { ::File.exist?("#{install_dir}/#{filename}") }
end

# Set ownership on the composer directory
directory "/home/#{user}/.composer" do
  owner "#{user}"
end
