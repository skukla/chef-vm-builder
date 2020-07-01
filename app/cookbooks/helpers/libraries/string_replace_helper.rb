#
# Cookbook:: helpers
# Library:: string_replace_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module StringReplaceHelper
    def self.set_php_sendmail_path(php_type, php_version, sendmail_path)
        file = Chef::Util::FileEdit.new("/etc/php/#{php_version}/#{php_type}/php.ini")
        file.insert_line_if_no_match(/^sendmail_path =/, "#{sendmail_path}")
        file.search_file_replace_line(/^sendmail_path =/, "sendmail_path =#{sendmail_path}")
        file.write_file
    end
    
    def self.set_java_home(file, java_home)
        file = Chef::Util::FileEdit.new("#{file}")
        file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
        file.write_file
    end

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
    
    def self.set_project_stability(stability_level, composer_json)
        replace_string_format = "%4s\"minimum-stability\": \"#{stability_level}\","
        file = Chef::Util::FileEdit.new("#{composer_json}")
        file.search_file_replace_line("minimum-stability", sprintf(replace_string_format, "\s"))
        file.write_file
    end

    def self.update_sort_packages(composer_json)
        replace_string_format = "%8s\"sort-packages\": false"
        file = Chef::Util::FileEdit.new("#{composer_json}")
        file.search_file_replace_line("sort-packages", sprintf(replace_string_format, "\s"))
        file.write_file
    end

    def self.update_app_version(user, version, family, web_root, composer_json)
        output_file = "#{web_root}/new_composer.json"
        File.open(output_file, "a") do |output|
            File.foreach("#{web_root}/#{composer_json}") do |line|
                if line.include?("product-#{family}-edition") || line.include?("version")
                    output.write(line.gsub(/(\d{1})\.(\d{1})\.(\d{1})('-'.)?/, version))
                else
                    output.write(line)
                end
            end
        end
        FileUtils.mv(output_file, "#{web_root}/#{composer_json}")
        FileUtils.chmod(0664, "#{web_root}/#{composer_json}")
        FileUtils.chown("vagrant", "vagrant", "#{web_root}/#{composer_json}")
    end
end