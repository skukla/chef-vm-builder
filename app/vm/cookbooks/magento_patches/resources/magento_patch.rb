#
# Cookbook:: magento_patches
# Resource:: magento_patch
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_patch
provides :magento_patch

property :name, String, name_property: true
property :user, String, default: node[:magento_patches][:init][:user]
property :group, String, default: node[:magento_patches][:init][:user]
property :web_root, String, default: node[:magento_patches][:nginx][:web_root]
property :magento_version,
         String,
         default: node[:magento_patches][:magento][:version]
property :sample_data_flag,
         [TrueClass, FalseClass],
         default: node[:magento_patches][:magento][:sample_data]
property :composer_file,
         String,
         default: node[:magento_patches][:composer][:file]
property :patches_repository_url,
         String,
         default: node[:magento_patches][:repository_url]
property :patches_branch, String, default: node[:magento_patches][:branch]
property :directory_in_repository,
         String,
         default: node[:magento_patches][:repository_directory]
property :directory_in_codebase,
         String,
         default: node[:magento_patches][:codebase_directory]
property :patches_holding_area,
         String,
         default: node[:magento_patches][:holding_area]
property :chef_patches_directory,
         String,
         default: node[:magento_patches][:chef_files][:path]

action :remove_holding_area do
	execute 'Remove patches holding area' do
		command "rm -rf #{new_resource.patches_holding_area}"
		only_if { ::Dir.exist?(new_resource.patches_holding_area) }
	end
end

action :create_holding_area do
	directory 'Patches holding area' do
		path new_resource.patches_holding_area
		owner new_resource.user
		group new_resource.group
		mode '755'
		not_if { ::Dir.exist?(new_resource.patches_holding_area) }
	end
end

action :remove_from_web_root do
	execute 'Remove patches from web root' do
		command "rm -rf #{new_resource.web_root}/#{new_resource.directory_in_codebase}"
		only_if do
			::Dir.exist?(
				"#{new_resource.web_root}/#{new_resource.directory_in_codebase}",
			)
		end
	end
end

action :clone_patches_repository do
	bash "Cloning the #{new_resource.patches_branch} branch from the #{new_resource.patches_repository_url} repository" do
		code "git clone --single-branch --branch #{new_resource.patches_branch} #{new_resource.patches_repository_url} ."
		cwd new_resource.patches_holding_area
		ignore_failure :quiet
		only_if do
			::Dir.exist?(new_resource.patches_holding_area) &&
				::Dir.empty?(new_resource.patches_holding_area)
		end
		not_if { ::Dir.exist?(new_resource.directory_in_codebase) }
	end
end

action :filter_directory do
	bash 'Pull out patches from repository' do
		code "git filter-branch --subdirectory-filter #{new_resource.directory_in_repository}"
		cwd new_resource.patches_holding_area
		ignore_failure :quiet
	end
end

action :add_custom_patches do
	custom_patches =
		::Dir.entries(new_resource.chef_patches_directory) - %w[. .. .gitignore]
	unless custom_patches.empty?
		custom_patches.each do |entry|
			cookbook_file "Copy patch: #{entry}" do
				source entry
				path "#{new_resource.patches_holding_area}/#{entry}"
			end
		end
	end
end

action :rename_patches do
	ruby_block 'Rename patches' do
		block do
			PatchHelper.define_sample_data_patches(
				new_resource.patches_holding_area,
				new_resource.sample_data_flag,
			)
		end
	end
end

action :move_into_web_root do
	execute 'Move patches into hotfixes directory' do
		command "mv #{new_resource.patches_holding_area} #{new_resource.web_root}/#{new_resource.directory_in_codebase}"
	end
end

action :revert_patches do
	php 'Revert patches using ECE Tools' do
		action :run
		command_list './vendor/bin/ece-patches revert'
	end
end

action :apply_patches do
	php 'Apply patches using ECE Tools' do
		action :run
		command_list './vendor/bin/ece-patches apply'
	end
end
