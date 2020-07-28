#
# Cookbook:: helpers
# Library:: demo_structure_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module DemoStructureHelper
    def self.get_vhost_data(custom_demo_structure_data)
        vhost_data = Array.new
        custom_demo_structure_data.each do |scope, scope_hash|
            scope_hash.each do |code, url|
                demo_data = Hash.new
                if scope == "store_view"
                    demo_data[:scope] = scope.gsub("store_view", "store")
                else
                    demo_data[:scope] = scope
                end
                demo_data[:code] = code
                demo_data[:url] = url
                vhost_data << demo_data
            end
        end
        return vhost_data
    end
    def self.get_vhost_urls(custom_demo_structure_data)
        demo_urls = Array.new
        custom_demo_structure_data.each do |scope, scope_hash|
            scope_hash.each do |code, url|
                demo_urls << url
            end
        end
        return demo_urls
    end
end