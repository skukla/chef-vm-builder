#
# Cookbook:: ssl
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
ssl "Manage ssl certificates" do
    action [:remove_certificates, :generate_certificate, :refresh_certificate_list]
end