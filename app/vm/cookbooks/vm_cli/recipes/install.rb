# Cookbook:: vm_cli
# Recipe:: install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

vm_cli 'Installing VM CLI' do
  action %i[install_commands install_bashrc]
end
