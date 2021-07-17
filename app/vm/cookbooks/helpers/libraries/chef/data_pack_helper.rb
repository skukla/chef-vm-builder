# Cookbook:: helpers
# Library:: data_pack_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module DataPackHelper
  def self.data_pack_exists?(data_pack_source)
    @chef_files_path = Chef.node.default['magento_demo_builder']['chef_files']['path']
    @chef_files = Dir["#{@chef_files_path}/*"]

    return false if @chef_files.nil? || @chef_files.empty?

    @result_arr = []
    @chef_files.each do |entry|
      @entry_path = [File.dirname(entry), File.basename(entry)].join('/').split('/').pop(1).join
      @result_arr << entry if data_pack_source == @entry_path
    end

    !@result_arr.empty?
  end

  def self.prepare_data_pack_names(package_name, repository_url)
    @default_vendor_name = Chef.node.default['magento_demo_builder']['data_pack']['vendor']

    return if package_name.nil? || repository_url.nil?

    if package_name.include?('/')
      vendor_name = package_name.split('/')[0]
      module_name = package_name.split('/')[1]
    else
      vendor_name = @default_vendor_name
      module_name = repository_url
    end
    if (repository_url.nil? || repository_url.empty?) && repository_url.include?('github')
      package_name = "#{vendor_name}/#{module_name}"
    end
    vendor_string = if vendor_name.include?('-')
                      vendor_name.split('-').map(&:capitalize).join
                    else
                      vendor_name.capitalize
                    end
    module_string = if module_name.include?('-')
                      module_name.split('-').map(&:capitalize).join
                    else
                      module_name.capitalize
                    end
    {
      package_name: package_name,
      vendor_name: vendor_name,
      module_name: module_name,
      vendor_string: vendor_string,
      module_string: module_string
    }
  end
end
