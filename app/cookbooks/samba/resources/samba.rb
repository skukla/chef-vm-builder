#
# Cookbook:: samba
# Resource:: samba 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :samba
provides :samba

property :name,                    String, name_property: true
property :user,                    String, default: node[:samba][:init][:user]
property :group,                   String, default: node[:samba][:init][:user]
property :shares,                  Hash
property :share_fields,            Array, default: node[:samba][:share_fields]
property :hostname,                String, default: node[:hostname]

action :uninstall do
    apt_package "samba" do
        action [:remove, :purge]
    end    
end

action :install do
    apt_package 'samba' do
        action :install
    end
end

action :configure do
    # Prepare share data - selected_shares here is an Autovivified hash
    selected_shares = Hash.new {|h, k| h[k] = Hash.new(0) }
    new_resource.shares.each do |share_name, share_record|
        share_data = Hash.new
        new_resource.share_fields.each do |field|
            case field
            when :path
                if share_record.is_a? String
                    share_data[:path] = share_record
                else
                    share_data[field] = ValueHelper.process_value(share_record[field])
                end
            when :public, :browsable, :writeable
                share_data[field] = "Yes" if share_record[field.to_s].nil?
            when :force_user, :force_group
                if share_record[field.to_s].nil?
                    share_data[field] = "#{new_resource.user}"
                else
                    share_data[field] = ValueHelper.process_value(share_record[field])
                end
            else
                unless share_record[field.to_s].nil?
                    share_data[field] = ValueHelper.process_value(share_record[field])
                end
            end
        end
        selected_shares[share_name] = share_data
    end

    # Configure Samba
    template "Configure Samba" do
        source "smb.conf.erb"
        path "/etc/samba/smb.conf"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "644"
        variables({
            hostname: "#{new_resource.hostname}",
            shares: selected_shares
        })
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