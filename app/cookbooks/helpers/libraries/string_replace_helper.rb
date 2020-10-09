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
        
        if (!selected_modules.is_a? Chef::Node::ImmutableArray) && (!selected_modules.empty?)
            modules_to_remove << selected_modules
        else
            selected_modules.each do |selected_module|
                modules_to_remove << selected_module
            end
        end
        replace_string_format = "%4s%s:"
        module_format = "%8s\"%s\": \"*\""
        replace_block_format = "%s{\n%s\n%4s},\n"
        
        modules_list = Array.new
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

    def self.prepare_module_names(package_name, vendor)
        unless package_name.nil?
            if !package_name.include?("module-")
                package_name = "module-#{package_name}"
            end
            if package_name.include?("/")
                vendor_name = package_name.split("/")[0]
                module_name = package_name.split("/")[1]
            else
                module_name = package_name
                vendor_name = vendor
            end
            if module_name.include?("-")
                module_name = module_name.split("-").map{ |value| value.capitalize }.join
            end
            if vendor_name.include?("-")
                vendor_name = vendor_name.split("-").map{ |value| value.capitalize }.join
            end
            return {
                package_name: package_name,
                vendor: vendor_name,
                module_name: module_name.sub("Module", "")
            }
        end
    end
end