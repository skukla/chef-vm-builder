# Cookbook:: search_engine
# Recipe:: elasticsearch
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

java 'Install Java' do
	action :install
end

java 'Set java_home in elasticsearch app file' do
	action :set_java_home
end

elasticsearch 'Install Elasticsearch and Elasticsearch plugins and restart' do
	action %i[install_app replace_service_file]
end

elasticsearch 'Install plugins' do
	action :install_plugins
end

elasticsearch 'Configure Elasticsearch JVM options and Elasticsearch application' do
	action %i[configure_jvm_options configure_app]
end

elasticsearch "Enable Elasticsearch and make sure it's stopped" do
	action %i[enable stop]
end
