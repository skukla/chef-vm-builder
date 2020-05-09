#
# Cookbook:: magento
# Recipe:: set_project_stability
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:installation][:options][:directory]
minimum_stability = node[:magento][:installation][:options][:minimum_stability]
composer_file = node[:magento][:composer_filename]

unless minimum_stability.empty?
    ruby_block "Set project minimum stability" do
        block do
            replace_string_format = "%4s\"minimum-stability\": \"#{minimum_stability}\","
            file = Chef::Util::FileEdit.new("#{web_root}/composer.json")
            file.search_file_replace_line("minimum-stability", sprintf(replace_string_format, "\s"))
            file.write_file
        end
        only_if { ::File.exist?("#{web_root}/composer.json") }
    end
end