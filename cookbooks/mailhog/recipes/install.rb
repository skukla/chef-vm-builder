#
# Cookbook:: mailhog
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
repositories = node[:infrastructure][:mailhog][:repositories]

# Clone the Mailhog and MHSendmail repositories
repositories.each do |repository|
    execute "Use go to clone #{repository[:name]}" do
        command "go get #{repository[:url]}"
    end
    # Copy files into necessary places
    execute "Copy #{repository[:name]} into /usr/local/bin" do
        command "sudo cp /root/go/bin/#{repository[:name]} /usr/local/bin/#{repository[:name].downcase}"
    end
end
