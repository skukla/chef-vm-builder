# Cookbook:: helpers
# Library:: app/composer_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ComposerHelper
  def ComposerHelper.require_string(module_list)
    module_list.map { |md| "#{md.package_name}:#{md.version}" }.join(' ')
  end
end
