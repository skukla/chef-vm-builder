#
# Cookbook:: samba
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attribtues
user = node[:infrastructure][:samba][:user]
group = node[:infrastructure][:samba][:group]
share_data = node[:infrastructure][:samba][:shares]
share_settings = node[:infrastructure][:samba][:share_settings] 

# Get share data
selected_shares = Array.new
share_data.each do |share_name, share_selected|
    next unless share_selected
    share_settings.each do |share_key, share_info|
        if share_name == share_key
            share_hash = Hash.new
            share_hash[:title] = share_info[:title]
            share_hash[:comment] = share_info[:comment]
            share_hash[:path] = share_info[:path]
            share_hash[:writable] = share_info[:writable]
            share_hash[:browsable] = share_info[:browsable]
            share_hash[:read_only] = share_info[:read_only]
            share_hash[:guest_ok] = share_info[:guest_ok]
            share_hash[:public] = share_info[:public]
            share_hash[:force_user] = "#{user}"
            share_hash[:force_group] = "#{group}"
            selected_shares << share_hash
        end
    end
end

# Configure Samba
template 'Configure Samba' do
    source 'smb.conf.erb'
    path '/etc/samba/smb.conf'
    owner "#{user}"
    group "#{group}"
    mode '644'
    variables({
        shares: selected_shares
    })
end

# Define, enable, and start the Samba service
service 'smbd' do
    action [:enable, :start]
end
