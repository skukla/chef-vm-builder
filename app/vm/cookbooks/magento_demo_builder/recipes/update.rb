# Cookbook:: magento_demo_builder
# Recipe:: update
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = node[:magento_demo_builder][:github_data_pack_list]
build_action = node[:magento_demo_builder][:magento][:build][:action]

if !data_pack_list.empty? && build_action == 'update_data'
  require_str = ComposerHelper.require_string(data_pack_list)

  composer "Updating #{require_str} code" do
    action :update
    package_name require_str
  end
end
