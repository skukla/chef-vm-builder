require_relative 'system'

class ElasticsearchDependencies
  def ElasticsearchDependencies.xcode_missing?
    System.cmd('xcode-select -p')
    !$?.exitstatus.zero?
  end

  def ElasticsearchDependencies.homebrew_missing?
    System.cmd('which -s brew')
    !$?.exitstatus.zero?
  end
end
