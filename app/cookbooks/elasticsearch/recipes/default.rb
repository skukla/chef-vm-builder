#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_elasticsearch = node[:elasticsearch][:use]
elasticsearch_host = node[:elasticsearch][:host]

elasticsearch 'Stop and uninstall Elasticsearch' do
  action :uninstall
end

java 'Uninstall Java' do
  action :uninstall
  only_if { !use_elasticsearch }
end

java 'Install Java' do
  action :install
  only_if do
    use_elasticsearch &&
      ['127.0.0.1', 'localhost'].include?(elasticsearch_host)
  end
end

java 'Set java_home in elasticsearch app file' do
  action :set_java_home
  only_if do
    use_elasticsearch &&
      ['127.0.0.1', 'localhost'].include?(elasticsearch_host)
  end
end

elasticsearch 'Install Elasticsearch and Elasticsearch plugins and restart' do
  action %i[install_app replace_service_file]
  only_if do
    use_elasticsearch &&
      ['127.0.0.1', 'localhost'].include?(elasticsearch_host)
  end
end

elasticsearch 'Install plugins' do
  action :install_plugins
  only_if do
    use_elasticsearch &&
      ['127.0.0.1', 'localhost'].include?(elasticsearch_host)
  end
end

elasticsearch 'Configure Elasticsearch JVM options and Elasticsearch application' do
  action %i[configure_jvm_options configure_app]
  only_if do
    use_elasticsearch &&
      ['127.0.0.1', 'localhost'].include?(elasticsearch_host)
  end
end

elasticsearch "Enable Elasticsearch and make sure it's stopped" do
  action %i[enable stop]
  only_if do
    use_elasticsearch &&
      ['127.0.0.1', 'localhost'].include?(elasticsearch_host)
  end
end
