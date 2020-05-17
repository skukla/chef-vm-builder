#
# Cookbook:: helpers
# Library:: modules_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module ModulesHelper
    def self.remove_modules(selected_modules, composer_json)
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
        file = Chef::Util::FileEdit.new("#{composer_json}")
        file.insert_line_after_match("minimum-stability", sprintf(replace_block_format, sprintf(replace_string_format, "\s", "\"replace\""), modules_list.join(",\n"), "\s"))
        file.write_file
    end 
end