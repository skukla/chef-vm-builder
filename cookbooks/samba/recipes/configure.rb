#
# Cookbook:: samba
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
hostname = node[:hostname]
share_fields = node[:samba][:share_fields]
shares = node[:samba][:shares]

# Helper method
def process_value(value)
    if value == true
        return "Yes"
    elsif value == false
        return "No"
    end
    return value
end

# Get share data
# selected_shares here is an Autovivified hash
selected_shares = Hash.new {|h, k| h[k] = Hash.new(0) }
shares.each do |share_name, share_record|
    share_data = Hash.new
    share_fields.each do |field|
        case field
        when :path
            if share_record.is_a? String
                share_data[:path] = share_record
            else
                share_data[field] = process_value(share_record[field])
            end
        when :public, :browsable, :writeable
            share_data[field] = "Yes" if share_record[field.to_s].nil?
        when :force_user, :force_group
            if share_record[field.to_s].nil?
                share_data[field] = "#{user}"
            else
                share_data[field] = process_value(share_record[field])
            end
        else
            unless share_record[field.to_s].nil?
                share_data[field] = process_value(share_record[field])
            end
        end
    end
    selected_shares[share_name] = share_data
end

# Configure Samba
template 'Configure Samba' do
    source 'smb.conf.erb'
    path '/etc/samba/smb.conf'
    owner "#{user}"
    group "#{group}"
    mode '644'
    variables({
        hostname: "#{hostname}",
        shares: selected_shares
    })
end

# Enable the smbd service
service 'smbd' do
    action :enable
end