#
# Cookbook:: elasticsearch
# Resource:: java
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :java
provides :java

property :name, String, name_property: true
property :package_name, String, default: node[:elasticsearch][:java][:package]
property :java_home, String, default: node[:elasticsearch][:java][:home]
property :environment_file,
         String,
         default: node[:elasticsearch][:java][:environment_file]

action :uninstall do
	execute 'Uninstall Java' do
		command "apt-get purge --auto-remove #{new_resource.package_name} -y"
		only_if { ::Dir.exist?(new_resource.java_home) }
	end
end

action :install do
	apt_package new_resource.package_name do
		action :install
		not_if { ::Dir.exist?(new_resource.java_home) }
	end
end

action :set_java_home do
	template 'Java environment file' do
		source 'java.environment.erb'
		path new_resource.environment_file
		user 'root'
		group 'root'
		variables({ java_home: new_resource.java_home })
		only_if { ::Dir.exist?('/etc/elasticsearch') }
	end
end
