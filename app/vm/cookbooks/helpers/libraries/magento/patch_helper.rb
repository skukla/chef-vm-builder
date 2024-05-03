# Cookbook:: helpers
# Library:: chef/patch_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class PatchHelper
  def PatchHelper.define_sample_data_patches(
    patch_file_directory,
    sample_data_flag
  )
    files = Dir.entries(patch_file_directory) - %w[.. . .git]
    file_list =
      files.each_with_object([]) do |file, arr|
        if open("#{patch_file_directory}/#{file}") do |f|
             f.each_line.detect { |line| /sample-data/.match(line) }
           end
          arr << file
        end
      end
    return if file_list.empty?

    file_list.each do |file|
      if sample_data_flag && file.include?('.disabled')
        File.rename(
          "#{patch_file_directory}/#{file}",
          "#{patch_file_directory}/#{file}".sub('.disabled', ''),
        )
        puts "Enabled #{file}.disabled"
      elsif !sample_data_flag && !file.include?('.disabled')
        File.rename(
          "#{patch_file_directory}/#{file}",
          "#{patch_file_directory}/#{file}.disabled",
        )
        puts "Disabled #{file}"
      end
    end
  end

  def PatchHelper.patches_branch
    base_version = MagentoHelper.base_version
    ref_branch = "pmet-#{base_version}-ref"
    blank_branch = "pmet-#{base_version}-blank"

    if VersionHelper.is_requested_newer?('2.4.6', base_version)
      ref_branch
    else
      blank_branch
    end
  end
end
