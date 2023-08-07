# Cookbook:: helpers
# Library:: chef/value
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module ValueHelper
  def ValueHelper.process_value(value)
    case value.to_s
    when 'true'
      return true
    when 'false'
      return false
    end

    value
  end

  def ValueHelper.bool_to_int(value)
    case value.to_s
    when 'true'
      return 1
    when 'false'
      return 0
    end

    value
  end

  def ValueHelper.github_source?(value)
    return nil if value.nil?

    value.include?('github')
  end

  def ValueHelper.strip_dashes(value)
    return value unless value.include?('-')

    value.split('-').map { |e| e }.join
  end

  def ValueHelper.prepare_filename(value)
    value = value.downcase

    return value unless value.include?(' ')

    value.split(' ').map { |e| e }.join('-')
  end
end
