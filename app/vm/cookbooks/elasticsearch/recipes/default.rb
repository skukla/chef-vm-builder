# Cookbook:: elasticsearch
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

java 'Install Java and set java_home in elasticsearch app file' do
	action %i[install set_java_home]
end

elasticsearch 'Install, configure, enable, and stop Elasticsearch' do
	action %i[
			install_app
			replace_service_file
			install_plugins
			configure_jvm_options
			configure_app
			enable
			stop
	       ]
end
