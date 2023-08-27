# Cookbook:: helpers
# Library:: app/composer_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ComposerHelper
  def ComposerHelper.require_string(module_list)
    module_list
      .map do |md|
        version_string = "#{md.package_name}:#{md.version}"
        version_string += "##{md.reference}" if md.reference &&
          !md.reference.empty?
        version_string
      end
      .join(' ')
  end
end
