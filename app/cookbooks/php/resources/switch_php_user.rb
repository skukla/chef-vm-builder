# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :switch_php_user

action :run do
    if new_resource.name != "www-data"
        link "/usr/bin/php" do
            to "/etc/alternatives/php"
            action :delete
        end
        
        link "/usr/bin/php" do
            to "/bin/php.sh"
            action :create
        end
        
        execute "Make PHP script executable" do
            command "sudo chmod +x /bin/php.sh"
        end
    else
        link "/usr/bin/php" do
            to "/bin/php.sh"
            action :delete
        end
        
        link "/usr/bin/php" do
            to "/etc/alternatives/php"
            action :create
        end
        
        execute "Make PHP script non-executable" do
            command "sudo chmod -x /bin/php.sh"
            only_if { ::File.exist?("/bin/php.sh") }
        end
    end
end