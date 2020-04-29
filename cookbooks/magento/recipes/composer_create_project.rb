#
# Cookbook:: magento
# Recipe:: composer_create_project
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
magento_family = node[:application][:installation][:options][:family]
magento_family = 'enterprise' if magento_family == 'Commerce'
magento_version = node[:application][:installation][:options][:version]
github_token = node[:application][:authentication][:composer][:github_token]
composer_username = node[:application][:authentication][:composer][:username]
composer_password = node[:application][:authentication][:composer][:password]
composer_file = node[:magento][:composer][:filename]

# Move auth.json into place
template "Add composer credentials" do
    source 'auth.json.erb'
    path "/home/#{user}/.composer/auth.json"
    owner "#{user}"
    group "#{group}"
    mode '664'
    variables({
        username: "#{composer_username}",
        password: "#{composer_password}",
        github_token: "#{github_token}"
    })
    only_if { ::File.directory?("/home/#{user}/.composer") }
end

# Create project string
create_project_string = "create-project --no-install --repository-url=https://repo.magento.com/ magento/project-#{magento_family.downcase}-edition=#{magento_version} ."

# Create base composer.json for base code
execute "Create Magento composer.json" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} #{create_project_string}'"
end


