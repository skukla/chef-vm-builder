#
# Cookbook:: magento
# Recipe:: apply_patches
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:app_patches][:user]
group = node[:app_patches][:user]
web_root = node[:app_patches][:web_root]
composer_file = node[:app_patches][:composer_file]

# Pull out the patches subdirectory
execute "Pull out patches from repository" do
    command "cd /var/www/patches && git filter-branch --subdirectory-filter m2-hotfixes"
end

# Move patches into web root
execute "Move patches into web root" do
    command "mv /var/www/patches #{web_root}/m2-hotfixes"
    only_if { ::File.directory?("/var/www/patches") }
end

# Create the patch file
ruby_block 'Build patch file' do
    block do
        require 'json'
        files = Dir["#{web_root}/m2-hotfixes/*.patch"].sort!
        file_hash = {}
        module_hash = {}
        patches_file = "#{web_root}/m2-hotfixes/patches.json"
        
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
    only_if { ::File.directory?("#{web_root}/m2-hotfixes") }
end

# Update patch permissions
execute "Update patch permissions" do
    command "sudo chown #{user}:#{group} -R #{web_root}/m2-hotfixes"
    only_if { ::File.directory?("#{web_root}/m2-hotfixes") }
end

# Update the composer file
execute "Add the patches file to composer.json" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} config extra.patches-file m2-hotfixes/patches.json'"
end
