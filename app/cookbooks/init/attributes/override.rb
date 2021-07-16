# Cookbook:: init
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings:
# vm: ip, name
# os: update, timezone
# custom_demo: structure{}
#
# frozen_string_literal: true

settings = [
	{ path: %w[vm ip], value: ConfigHelper.setting('vm/ip') },
	{
		path: %w[os update],
		value: ConfigHelper.setting('infrastructure/os/update'),
	},
	{
		path: %w[os timezone],
		value: ConfigHelper.setting('infrastructure/os/timezone'),
	},
	{
		path: %w[custom_demo structure],
		value: ConfigHelper.setting('custom_demo/structure'),
	},
]

settings
	.reject { |s| s[:value].to_s.empty? }
	.each { |s| override[:init][s[:path][0]][s[:path][1]] = s[:value] }

exit
