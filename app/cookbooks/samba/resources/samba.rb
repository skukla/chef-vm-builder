#
# Cookbook:: samba
# Resource:: samba
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :samba
provides :samba

property :name,                    String, name_property: true
property :hostname,                String, default: node[:hostname]
property :user,                    String, default: node[:samba][:init][:user]
property :group,                   String, default: node[:samba][:init][:user]
property :share_fields,            Array,  default: node[:samba][:share_fields]
property :share_list,              Hash,   default: node[:samba][:share_list]

action :uninstall do
  apt_package 'samba' do
    action %i[remove purge]
    only_if { ::File.directory?('/etc/samba') }
  end
end

action :install do
  apt_package 'samba' do
    action :install
    not_if { ::File.exist?('/lib/systemd/system/smbd.service') }
  end
end

action :configure do
  # Prepare share data - selected_shares here is an Autovivified hash
  selected_shares = Hash.new { |h, k| h[k] = Hash.new(0) }
  new_resource.share_list.each do |share_name, share_record|
    share_data = {}
    new_resource.share_fields.each do |field|
      case field
      when :path
        if share_record.is_a? String
          share_data[:path] = share_record
        else
          share_data[field] = ValueHelper.process_value(share_record[field])
        end
      when :public, :browseable, :writeable
        share_data[field] = 'Yes' if share_record[field.to_s].nil?
      when :force_user, :force_group
        share_data[field] = if share_record[field.to_s].nil?
                              new_resource.user.to_s
                            else
                              ValueHelper.process_value(share_record[field])
                            end
      else
        share_data[field] = ValueHelper.process_value(share_record[field]) unless share_record[field.to_s].nil?
      end
    end
    selected_shares[share_name] = share_data
  end

  # Configure Samba
  template 'Configure Samba' do
    source 'smb.conf.erb'
    path '/etc/samba/smb.conf'
    owner new_resource.user
    group new_resource.group
    mode '644'
    variables({
                hostname: new_resource.hostname,
                share_list: selected_shares
              })
  end
end

action :create_magento_shares do
  %i[product_media_share content_media_share backups_share].each do |drop_directory|
    next unless new_resource.share_list.key?(drop_directory)

    if (new_resource.share_list[drop_directory].is_a? String) && !new_resource.share_list[drop_directory].empty?
      media_drop_path = new_resource.share_list[drop_directory]
    elsif new_resource.share_list[drop_directory].key?(:path) && !new_resource.share_list[drop_directory][:path].empty?
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
