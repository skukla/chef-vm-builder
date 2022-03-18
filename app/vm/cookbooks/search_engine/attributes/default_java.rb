# Cookbook:: search_engine
# Attribute:: default_java
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:search_engine][:elasticsearch][:java][:user] = 'root'
default[:search_engine][:elasticsearch][:java][:group] = 'root'
default[:search_engine][:elasticsearch][:java][:package] = 'openjdk-11-jdk'
default[:search_engine][:elasticsearch][:java][:home] =
	"/usr/lib/jvm/java-11-openjdk-#{MachineHelper.arch}"
default[:search_engine][:elasticsearch][:java][:environment_file] =
	'/etc/environment'
