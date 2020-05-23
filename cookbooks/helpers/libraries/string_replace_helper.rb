#
# Cookbook:: helpers
# Library:: string_replace_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module StringReplaceHelper
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
    
    def self.set_minimum_stability(stability_level, composer_json)
        replace_string_format = "%4s\"minimum-stability\": \"#{stability_level}\","
        file = Chef::Util::FileEdit.new("#{composer_json}")
        file.search_file_replace_line("minimum-stability", sprintf(replace_string_format, "\s"))
        file.write_file
    end

    def self.upgrade_app_version(version, family, composer_json)
        replace_string_format = "%4s\"%s\": \"#{version}\","
        file = Chef::Util::FileEdit.new("#{composer_json}")
        file.search_file_replace_line("version", sprintf(replace_string_format, "\s", "version"))
        file.search_file_replace_line("magento/product-#{family}-edition", sprintf(replace_string_format, "\s", "magento/product-#{family}-edition"))
        file.write_file
    end

    def self.set_java_home(file, java_home)
        file = Chef::Util::FileEdit.new("#{file}")
        file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.write_file
    end
end