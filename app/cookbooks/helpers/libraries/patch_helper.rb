#
# Cookbook:: helpers
# Library:: patch_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module PatchHelper
  def self.define_sample_data_patches(patch_file_directory, sample_data_flag)
    files = Dir.entries(patch_file_directory) - ['..', '.', '.git']
    file_list = []
    files.each do |file|
      if open("#{patch_file_directory}/#{file}") { |f| f.each_line.detect { |line| /sample-data/.match(line) } }
        file_list << file
      end
    end
    return if file_list.empty?

    file_list.each do |file|
      if sample_data_flag && file.include?('.disabled')
        File.rename("#{patch_file_directory}/#{file}", "#{patch_file_directory}/#{file}".sub('.disabled', ''))
        puts "Enabled #{file}.disabled"
      elsif !sample_data_flag && !file.include?('.disabled')
        File.rename("#{patch_file_directory}/#{file}", "#{patch_file_directory}/#{file}.disabled")
        puts "Disabled #{file}"
      end
    end
  end
end
