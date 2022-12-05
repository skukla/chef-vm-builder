# Cookbook:: helpers
# Library:: custom_modules/custom_module_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true
class CustomModuleHelper
  def CustomModuleHelper.list
    list = ConfigHelper.value('custom_demo/custom_modules')
    return [] if list.nil? || list.empty?

    list.map { |md| ModuleSharedHelper.prepare_data(md, :cm) }
  end
end
