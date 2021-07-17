# Cookbook:: webmin
# Attribute:: override
#
# Supported settings: use, port
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = node[:infrastructure][:webmin]

override[:webmin][:use] = setting if setting.is_a?(TrueClass) || setting.is_a?(FalseClass)
override[:webmin][key] = setting[key] if setting.is_a?(Hash) && !setting.empty?
