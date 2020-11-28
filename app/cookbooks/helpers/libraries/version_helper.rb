#
# Cookbook:: helpers
# Library:: version_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module VersionHelper
  def self.get_base_version(version)
    if version.include?('-p')
      version.sub(/.{3}$/, '')
    else
      version
    end
  end

  def self.check_version(lower_bound, operator, upper_bound)
    Gem::Version.new(VersionHelper.get_base_version(lower_bound)).send(operator, Gem::Version.new(upper_bound))
  end
end
