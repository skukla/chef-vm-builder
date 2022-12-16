# Cookbook:: magento_modules
# Resource:: module_data
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :module_data
provides :module_data

property :module_list, Array

action :add_repositories do
  new_resource.module_list.each do |md|
    composer "Adding github repository: #{md.module_string}" do
      action :add_repository
      module_name md.module_string
      repository_url md.source
    end
  end
end

action :add_modules do
  unless new_resource.module_list.nil? || new_resource.module_list.empty?
    require_str = ComposerHelper.require_string(new_resource.module_list)

    composer "Adding modules: #{require_str}" do
      action :require
      package_name require_str
      options %w[no-update]
    end
  end
end
