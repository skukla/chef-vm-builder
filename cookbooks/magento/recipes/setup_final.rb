#
# Cookbook:: magento
# Recipe:: setup_final
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
deploy_mode = node[:application][:installation][:options][:deploy_mode][:mode]
apply_deploy_mode_flag = node[:application][:installation][:options][:deploy_mode][:apply]

# Update files/folders ownership
directories = ['var/', 'pub/', 'app/etc/', 'generated/', 'generated/code/']
directories.each do |directory|
    directory "Setting permissions for #{directory}" do
        path "#{web_root}/#{directory}"
        owner "#{user}"
        group "#{group}"
        mode '0777'
        recursive true
    end
end

# Delete var/generated and set application deployment mode
if apply_deploy_mode_flag
    directory "Remove generated directory" do
        path "#{web_root}/generated"
        recursive true
        action :delete
        only_if { ::File.directory?("#{web_root}/generated") }
    end

    execute "Set application mode" do
        command "su #{user} -c '#{web_root}/bin/magento deploy:mode:set #{deploy_mode}'"
    end
end

# Configure cron
execute "Configure cron" do
    command "su #{user} -c '#{web_root}/bin/magento cron:install'"
    not_if "su #{user} -c 'crontab -l'"
end

# Reindex
execute "Reindex" do
    command "su #{user} -c '#{web_root}/bin/magento indexer:reset && #{web_root}/bin/magento indexer:reindex'"
end
