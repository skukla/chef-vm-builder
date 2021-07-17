# Cookbook:: helpers
# Library:: string_replace_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module StringReplaceHelper
  def self.set_php_sendmail_path(php_type, php_version, sendmail_path)
    line_to_insert = sendmail_path.empty? ? ';sendmail_path =' : "sendmail_path = #{sendmail_path}"

    file = Chef::Util::FileEdit.new("/etc/php/#{php_version}/#{php_type}/php.ini")
    file.insert_line_if_no_match(/^sendmail_path =/, sendmail_path.to_s)
    file.search_file_replace_line(/^sendmail_path =/, line_to_insert)
    file.write_file
  end

  def self.set_java_home(file, java_home)
    file = Chef::Util::FileEdit.new(file.to_s)
    file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
    file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
    file.write_file
  end

  def self.remove_modules(selected_modules, composer_json)
    modules_to_remove = []

    if (!selected_modules.is_a? Chef::Node::ImmutableArray) && !selected_modules.empty?
      modules_to_remove << selected_modules
    else
      selected_modules.each do |selected_module|
        modules_to_remove << selected_module
      end
    end
    replace_string_format = '%4s%s:'
    module_format = '%8s"%s": "*"'
    replace_block_format = "%s{\n%s\n%4s},\n"

    modules_list = []
    modules_to_remove.each do |value|
      modules_list << format(module_format, "\s", value.to_s)
    end
    file = Chef::Util::FileEdit.new(composer_json.to_s)
    file.insert_line_after_match(
      'minimum-stability', format(
                             replace_block_format,
                             format(replace_string_format, "\s", '"replace"'),
                             modules_list.join(",\n"), "\s"
                           )
    )
    file.write_file
  end

  def self.set_project_stability(stability_level, composer_json)
    replace_string_format = "%4s\"minimum-stability\": \"#{stability_level}\","
    file = Chef::Util::FileEdit.new(composer_json.to_s)
    file.search_file_replace_line('minimum-stability', format(replace_string_format, "\s"))
    file.write_file
  end

  def self.update_sort_packages(composer_json)
    replace_string_format = '%8s"sort-packages": false'
    file = Chef::Util::FileEdit.new(composer_json.to_s)
    file.search_file_replace_line('sort-packages', format(replace_string_format, "\s"))
    file.write_file
  end

  def self.update_app_version(version, family, user, web_root, composer_json)
    output_file = "#{web_root}/new_composer.json"
    File.open(output_file, 'a') do |output|
      File.foreach("#{web_root}/#{composer_json}") do |line|
        if line.include?("product-#{family}-edition") || line.include?('version')
          output.write(line.gsub(/(\d{1})\.(\d{1})\.(\d{1})('-'.)?/, version))
        else
          output.write(line)
        end
      end
    end
    FileUtils.mv(output_file, "#{web_root}/#{composer_json}")
    FileUtils.chmod(0o664, "#{web_root}/#{composer_json}")
    FileUtils.chown(user, user, "#{web_root}/#{composer_json}")
  end
end