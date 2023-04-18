# Cookbook:: ssh
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

ssh 'Prepare ssh, add keys, and restart' do
  action %i[clear_ssh_directory create_ssh_config add_public_keys]
end
