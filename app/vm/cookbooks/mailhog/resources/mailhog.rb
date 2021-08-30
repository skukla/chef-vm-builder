#
# Cookbook:: mailhog
# Resource:: mailhog
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :mailhog
provides :mailhog

property :name, String, name_property: true
property :repository_list, Array, default: node[:mailhog][:repositories]
property :go_install_path, String, default: node[:mailhog][:go_install_path]
property :install_path, String, default: node[:mailhog][:install_path]
property :service_file, String, default: node[:mailhog][:service_file]
property :port, [String, Integer], default: node[:mailhog][:port]
property :smtp_port, [String, Integer], default: node[:mailhog][:smtp_port]

action :install do
	new_resource.repository_list.each do |repository|
		execute "Use go to clone #{repository[:name]}" do
			command "go get #{repository[:url]}"
		end
		execute "Copy #{repository[:name]} into /usr/local/bin" do
			command "cp #{new_resource.go_install_path}/bin/#{repository[:name]} #{new_resource.install_path}/#{repository[:name].downcase}"
		end
	end
end

action :configure do
	template 'Mailhog service' do
		source 'mailhog.service.erb'
		path '/etc/systemd/system/mailhog.service'
		owner 'root'
		group 'root'
		mode '0644'
		variables({ port: new_resource.port, smtp_port: new_resource.smtp_port })
	end
end

action :restart do
	service 'mailhog' do
		action :restart
	end
end

action :enable do
	service 'mailhog' do
		action :enable
	end
end

action :reload do
	execute 'Reload all daemons' do
		command 'systemctl daemon-reload'
	end
end

action :stop do
	service 'mailhog' do
		action :stop
	end
end
