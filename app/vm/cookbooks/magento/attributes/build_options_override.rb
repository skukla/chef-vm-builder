# Cookbook:: magento
# Attribute:: build_options_override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: action, sample_data, modules_to_remove, consumer_list deploy_mode {apply, mode}
#
# frozen_string_literal: true

setting = node[:application][:build]

if setting.is_a?(Hash) && !setting.empty?
  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:magento][:build][key] = setting[key] unless %w[deploy_mode patches hooks].include?(key)

    next unless key == 'deploy_mode' && (!setting[key].nil? || !setting[key].empty?)

    if setting[key].is_a?(Hash) && !setting[key].empty?
      setting[:deploy_mode].each do |deploy_key, deploy_value|
        next if deploy_value.nil? || (deploy_value.is_a?(String) && deploy_value.empty?)

        override[:magento][:build][key][deploy_key] = setting[key][deploy_key]
      end
    end
    if setting[key].is_a?(String)
      override[:magento][:build][:deploy_mode][:apply] = true
      override[:magento][:build][:deploy_mode][:mode] = setting[key]
    end
    if setting[key].is_a?(TrueClass)
      override[:magento][:build][:deploy_mode][:apply] = setting[key]
      override[:magento][:build][:deploy_mode][:mode] = 'production'
    end
    override[:magento][:build][:deploy_mode][:apply] = setting[key] if setting[key].is_a?(FalseClass)
  end
end
