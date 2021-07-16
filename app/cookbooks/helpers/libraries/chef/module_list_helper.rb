# Cookbook:: helpers
# Library:: module_list_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module ModuleListHelper
  def self.clean_up_module_data(module_directory)
    `cd #{module_directory} && find . -name '.DS_Store' -type f -delete`
    puts '.DS_Store files removed'

    `cd #{module_directory} && find . -name '.gitignore' -type f -delete`
    puts '.gitignore files removed'
  end

  def self.build_require_string(module_list)
    module_arr = []
    module_list.each do |value|
      package_string = value['name']
      package_string = [package_string, value['version']].join(':') unless value['version'].nil?
      module_arr << package_string
    end
    module_arr.uniq.join(' ')
  end
end
