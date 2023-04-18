# Cookbook:: helpers
# Library:: app/provider_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class ProviderHelper
  def ProviderHelper.value
    ConfigHelper.provider
  end

  def ProviderHelper.elasticsearch_host
    case
    when value.include?('virtualbox')
      '10.0.2.2'
    when %w[vmware docker].include?(value)
      '127.0.0.1'
    end
  end
end
