#
# Cookbook:: samba
# Resource:: samba
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :samba
provides :samba

property :name, String, name_property: true
property :hostname, String, default: node[:hostname]
property :user, String, default: node[:samba][:init][:user]
property :group, String, default: node[:samba][:init][:user]
property :service_file, String, default: node[:samba][:service_file]
property :configuration_directory,
         String,
         default: node[:samba][:configuration_directory]
property :share_list, Hash, default: node[:samba][:share_list]

action :install do
	apt_package 'samba' do
		action :install
		not_if { ::File.exist?(new_resource.service_file) }
	end

	directory 'Samba configuration' do
		path new_resource.configuration_directory
		not_if { ::Dir.exist?(new_resource.configuration_directory) }
	end
end

action :configure do
	template 'Configure Samba' do
		source 'smb.conf.erb'
		path '/etc/samba/smb.conf'
		owner new_resource.user
		group new_resource.group
		mode '644'
		variables(
			{
				hostname: new_resource.hostname,
				user: new_resource.user,
				group: new_resource.group,
				shares: new_resource.share_list,
			},
		)
		only_if { ::Dir.exist?(new_resource.configuration_directory) }
	end
end

action :create_magento_shares do
	%i[
		product_media_share
		content_media_share
		backups_share
	].each do |drop_directory|
		next unless new_resource.share_list.key?(drop_directory)

		if (new_resource.share_list[drop_directory].is_a? String) &&
				!new_resource.share_list[drop_directory].empty?
			media_drop_path = new_resource.share_list[drop_directory]
		elsif new_resource.share_list[drop_directory].key?(:path) &&
				!new_resource.share_list[drop_directory][:path].empty?
			media_drop_path = new_resource.share_list[drop_directory][:path]
		end
		directory 'Media Drop' do
			path media_drop_path
			owner new_resource.user
			group new_resource.group
			mode '777'
			recursive true
		end
	end
end

action :restart do
	service 'smbd' do
		action :restart
	end
end

action :enable do
	service 'smbd' do
		action :enable
	end
end
