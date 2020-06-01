#
# Cookbook:: helpers
# Library:: patch_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module PatchHelper
    def self.build_patch_file(patch_file_directory, patches_file)
        require 'json'
        files = Dir["#{patch_file_directory}/*.patch"].sort!
        file_hash = {}
        module_hash = {}
        
        files.each_with_index do |file, key|
            value = File.open(file, &:readline).split('/')[3]
            if value.match(/module-/) || value.match(/theme-/)
                result = "magento/#{value}"
            else
                result = "magento2-base"
            end
            file_hash[key] = file
            module_hash[key] = result
        end
        
        indexed_by_val = module_hash
            .group_by { |k,v| v }
            .transform_values { |vals| vals.map(&:first) }
        
        result = indexed_by_val.transform_values do |indexes|
            indexes.map do |idx|
                { "Patch #{idx}" => file_hash[idx] }
            end
        end
        
        result = {
        "patches" => result.transform_values { |arr| arr.reduce(&:merge) }
        }
        
        File.open(patches_file, "w+") do |file|
            file.puts(result.to_json)
        end
    end 
end