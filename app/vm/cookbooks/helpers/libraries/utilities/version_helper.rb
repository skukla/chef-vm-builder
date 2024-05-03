# Cookbook:: helpers
# Library:: helpers/utilities
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class VersionHelper
  def VersionHelper.is_requested_newer?(requested_version, current_version)
    Gem::Version.new(requested_version) >= Gem::Version.new(current_version)
  end
end
