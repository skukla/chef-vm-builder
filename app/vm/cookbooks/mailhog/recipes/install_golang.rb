# Cookbook:: mailhog
# Recipe:: install_golang
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

go_install_path = node[:mailhog][:go_install_path]

golang 'Install golang' do
  action :install
  not_if { ::Dir.exist?(go_install_path) }
end
