# Cookbook:: helpers
# Library:: modules/module_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module ModuleHelper
  class AppModule
    attr_reader :source, :reference

    def initialize(hash)
      @hash = hash
      @source = @hash['source']
      @reference = @hash['reference']
    end

    def github_url
      "https://#{ConfigHelper.value('application/authentication/composer/github_token')}@raw.githubusercontent.com"
    end

    def base_version
      return 'dev-master' if @hash['version'].nil?

      @hash['version']
    end

    def stripped_version
      result = base_version

      slugs = %w[dev- .x-dev]
      slugs.each do |slug|
        result = base_version.sub(slug, '') if base_version.include?(slug)
      end

      result
    end

    def version
      return '*' if @hash['version'].nil? && vendor_string == 'magento'

      base_version
    end

    def package_name
      return @source unless ValueHelper.github_source?(@source)

      segment = StringReplaceHelper.parse_source_url(@source)

      return nil if segment.nil?

      composer_url =
        [
          github_url,
          segment[:org],
          segment[:module],
          stripped_version,
          'composer.json',
        ].join('/')

      package_name =
        JSON.parse(SystemHelper.cmd("curl -s #{composer_url}"))['name']

      return nil if package_name.nil?

      package_name
    end

    def vendor_string
      package_name.split('/')[0]
    end

    def module_string
      return package_name unless package_name.include?('/')

      package_name.split('/')[1]
    end
  end

  class DataPack < AppModule
    def initialize(hash)
      super
      @default_vendor =
        Chef.node.default[:magento_demo_builder][:data_pack][:vendor]
    end

    def vendor_string
      return @default_vendor unless ValueHelper.github_source?(@source)

      return package_name unless package_name.include?('/')

      package_name.split('/')[0]
    end

    def load_dirs
      return [] if @hash['data'].nil? || @hash['data'].empty?

      @hash['data'].map { |dir| dir['path'] }.reject { |dir| dir.nil? }
    end

    def load_files
      return [] if @hash['data'].nil? || @hash['data'].empty?

      @hash['data'].map { |dir| dir['files'] }.reject { |dir| dir.nil? }
    end

    def module_prefix
      return 'vendor' if ValueHelper.github_source?(source)

      'app/code'
    end

    def module_path
      File.join(module_prefix, vendor_string, module_string)
    end
  end

  class ComposerPlugin < AppModule
    attr_reader :status

    def initialize(hash)
      super
      @status = hash['status']
    end
  end
end
