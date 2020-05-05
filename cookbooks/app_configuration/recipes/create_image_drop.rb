#
# Cookbook:: app_configuration
# Recipe:: create_image_drop
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:app_configuration][:user]
group = node[:app_configuration][:user]
shares = node[:app_configuration][:samba_shares]

# Add the image drop directory if it's been asked for
if shares.has_key?(:image_drop)
    if shares[:image_drop].is_a? String and !shares[:image_drop].empty?
        image_drop_path = shares[:image_drop]
    elsif shares[:image_drop].has_key?(:path) && !shares[:image_drop][:path].empty?
        image_drop_path = shares[:image_drop][:path]
    end
    directory "Image Drop" do
        path "#{image_drop_path}"
        owner "#{user}"
        group "#{group}"
        mode "777"
        recursive true
        not_if { ::File.directory?("#{image_drop_path}") }
    end
end