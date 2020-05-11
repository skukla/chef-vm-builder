#
# Cookbook:: magento
# Recipe:: remove_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
selected_modules = node[:magento][:installation][:build][:modules_to_remove]
composer_file = node[:magento][:composer_file]

ruby_block "Remove outdated core modules" do
    block do
        modules_to_remove = Array.new
        modules_list = Array.new
        unless (selected_modules.is_a? Chef::Node::ImmutableArray) && (selected_modules.empty?)
            modules_to_remove << selected_modules
        end
        replace_string_format = "%4s%s:"
        module_format = "%8s\"%s\": \"*\""
        between_format = ",%4s"
        replace_block_format = "%s{\n%s\n%4s},\n"
        modules_to_remove.each do |value|
            modules_list << sprintf(module_format, "\s", "#{value}")
        end
        file = Chef::Util::FileEdit.new("#{web_root}/composer.json")
        file.insert_line_after_match("minimum-stability", sprintf(replace_block_format, sprintf(replace_string_format, "\s", "\"replace\""), modules_list.join(",\n"), "\s"))
        file.write_file
    end
    only_if { ::File.exist?("#{web_root}/composer.json") }
end
