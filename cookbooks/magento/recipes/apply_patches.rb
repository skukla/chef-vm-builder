#
# Cookbook:: magento
# Recipe:: apply_patches
#
# 1. Scan folder to get file name
# 2. Read each file to find out affected Magento module?
# 3. Write out patches.json file from filenames
# 4. Add patches file to composer.json
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]

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
    command "su #{user} -c 'sudo chown #{user}:#{group} -R #{web_root}/m2-hotfixes'"
    only_if { ::File.directory?("#{web_root}/m2-hotfixes") }
end

# Update the composer file
execute "Add the patches file to composer.json" do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} config extra.patches-file m2-hotfixes/patches.json'"
end
