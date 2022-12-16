require_relative 'config'
class CustomModule
  def CustomModule.list
    Config.value('custom_demo/custom_modules')
  end

  def CustomModule.module_found?(module_arr)
    return false if list.nil? || list.empty?
    list.select { |custom_module| module_arr.include?(custom_module['source']) }
      .any?
  end
end
