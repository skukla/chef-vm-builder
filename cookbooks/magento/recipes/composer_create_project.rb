#
# Cookbook:: magento
# Recipe:: composer_create_project
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
group = node[:magento][:user]
web_root = node[:magento][:web_root]
magento_family = node[:magento][:installation][:options][:family]
magento_version = node[:magento][:installation][:options][:version]
composer_file = node[:magento][:composer_file]
github_token = node[:magento][:github_token]
composer_username = node[:magento][:composer_username]
composer_password = node[:magento][:composer_password]

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
base_string = "create-project --no-install --repository-url=https://repo.magento.com/"
magento_family = 'enterprise' if magento_family == 'Commerce'
version_string = "magento/project-#{magento_family.downcase}-edition=#{magento_version} ."
create_project_string = [base_string, version_string].join(" ")

# Create base composer.json for base code
execute "Create Magento composer.json" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} #{create_project_string}'"
end


