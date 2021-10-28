# Cookbook:: search_engine
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:type] = 'elasticsearch'
default[:search_engine][:elasticsearch][:host] = '10.0.2.2'
default[:search_engine][:elasticsearch][:port] = '9200'
default[:search_engine][:elasticsearch][:prefix] = DemoStructureHelper.base_url
