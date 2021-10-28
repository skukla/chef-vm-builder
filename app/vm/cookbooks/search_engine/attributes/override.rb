# Cookbook:: search_engine
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/search_engine')

override[:search_engine][:type] = setting if setting.is_a?(String)
