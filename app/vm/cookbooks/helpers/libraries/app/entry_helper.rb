# Cookbook:: helpers
# Library:: app/entry_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

require 'pathname'

class EntryHelper
  @entries_to_remove = %w[. .. .DS_Store .gitignore]

  def EntryHelper.path(path_str)
    Pathname(File.join(AppHelper.root, path_str))
  end

  def EntryHelper.file_exists?(file_path)
    File.exist?(file_path)
  end

  def EntryHelper.files_from(path)
    Dir.entries(file_path) - @entries_to_remove
  end

  def EntryHelper.pull_files(path, pattern)
    Dir.chdir(path)
    Dir.glob(pattern)
  end
end
