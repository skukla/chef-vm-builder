#
# Cookbook:: magento
# Recipe:: remove_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
composer_file = node[:application][:composer][:filename]
modules_to_remove = node[:application][:installation][:options][:download][:modules_to_remove]


# Remove outdated modules in the core code base (e.g. Temando, etc.)
ruby_block "Remove outdated core modules" do
    block do
        modules_list = []
        replace_string_format = "%4s%s:"
        module_format = "%8s\"%s\": \"*\""
        between_format = ",%4s"
        replace_block_format = "%s{\n%s\n%4s},\n"
        modules_to_remove.each do |key, value|
            modules_list << sprintf(module_format, "\s", "#{key}/#{value[:module]}")
        end
        file = Chef::Util::FileEdit.new("#{web_root}/composer.json")
        file.insert_line_after_match(/minimum-stability/, sprintf(replace_block_format, sprintf(replace_string_format, "\s", "\"replace\""), modules_list.join(",\n"), "\s"))
        file.write_file
    end
    only_if { ::File.exists?("#{web_root}/composer.json") }
end
