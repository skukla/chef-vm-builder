# Cookbook:: init
# Recipe:: motd
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

init 'Install MOTD and update hosts file' do
  action %i[install_motd update_hosts]
end
