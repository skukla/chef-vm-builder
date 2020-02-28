#
# Cookbook:: magento
# Recipe:: create_project
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:application][:webserver][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]
magento_family = node[:application][:installation][:options][:family]
magento_family = 'enterprise' if magento_family == 'Commerce'
magento_version = node[:application][:installation][:options][:version]
version_string = "=#{magento_version}" if magento_version != "*"
github_token = node[:application][:authentication][:composer][:github_token]
composer_username = node[:application][:authentication][:composer][:username]
composer_password = node[:application][:authentication][:composer][:password]

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
create_project_string = "create-project --no-install --repository-url=https://repo.magento.com/ magento/project-#{magento_family.downcase}-edition#{version_string} ."

# Create base composer.json for base code
execute "Create Magento composer.json " do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} #{create_project_string}'"
end


