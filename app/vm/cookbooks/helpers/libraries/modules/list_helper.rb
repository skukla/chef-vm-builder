# Cookbook:: helpers
# Library:: modules/list_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true
module ListHelper
  class ModuleList
    def initialize(module_list)
      @module_list = module_list
      @all_modules = list
    end

    def github_modules
      @all_modules.select { |md| ValueHelper.github_source?(md.source) }
    end

    def non_github_modules
      @all_modules.reject { |md| ValueHelper.github_source?(md.source) }
    end
  end

  class AppModuleList < ModuleList
    attr_reader :all_modules

    def initialize(module_list)
      super
    end

    def list
      return [] if @module_list.nil? || @module_list.empty?

      @module_list.map { |md| ModuleHelper::AppModule.new(md) }
    end
  end

  class DataPackList < ModuleList
    attr_reader :all_modules

    def initialize(module_list)
      super
    end

    def list
      return [] if @module_list.nil? || @module_list.empty?

      @module_list.map { |md| ModuleHelper::DataPack.new(md) }
    end
  end
end
