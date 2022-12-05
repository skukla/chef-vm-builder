# Cookbook:: helpers
# Library:: custom_modules/module_list_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ModuleListHelper
  def ModuleListHelper.list(arr, data_type)
    return [] if arr.nil? || arr.empty?

    arr.map { |md| ModuleSharedHelper.prepare_data(md, data_type) }
  end
end
