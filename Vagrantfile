#
# Vagrantfile
#
# This file:
#   1. Reads VM settings from config/vm.json for use in VM setup
#   2. Updates the demo settings configuration file with the IP from the VM settings file
#   3. Reads demo settings from config/demo.json for use as Chef attributes
#   4. Converts demo settings to a ruby hash and writes out /environments/vb.rb for Chef
#   5. Checks for particular Vagrant plugins based on provider
#   6. Configures VM settings based on provider
#   7. Runs the Chef provisioner
#
# Copyright 2020, Steve Kukla, All Rights Reserved.
require 'json'
system ("clear")

# Configuration file list
vm_settings_file = File.dirname(File.expand_path(__FILE__)) + '/config/vm.json'
demo_settings_file = File.dirname(File.expand_path(__FILE__)) + '/config/demo.json'
environment_file = File.dirname(File.expand_path(__FILE__)) + '/environments/vm.rb'

# Read the configuration json files
vm_settings = JSON.parse(File.read(vm_settings_file))
demo_settings = File.read(demo_settings_file)

# Start VM Setup
Vagrant.configure("2") do |config|
  
  # Plugin check (VMWare Fusion and Virtualbox will want different Vagrant plugins)
  config.trigger.before   :up do |trigger|
    trigger.name = "Checking for required plugins..."
    trigger.ruby do
      plugins = vm_settings['vagrant']['plugins']['all']
      if vm_settings['vm']['provider'] == 'virtualbox'
        plugins.push(*vm_settings['vagrant']['plugins']['virtualbox'])
      else
        plugins.push(*vm_settings['vagrant']['plugins']['vmware_desktop'])
      end
      plugins.each do |plugin|
        unless Vagrant.has_plugin?("#{plugin}")
          system("vagrant plugin install #{plugin}", :chdir=>"/tmp") || exit!
        end
      end
      sleep(1)
    end
  end

  # Update Demo Settings configuration with the IP from VM Settings configuration
  config.trigger.before [:up, :reload, :provision] do |trigger|
    trigger.name = 'Syncing configuration files...'
    trigger.ruby do
      File.write(demo_settings_file, demo_settings.gsub(/\"ip\": \"(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\"$/, "\"ip\": \"#{vm_settings['vm']['ip']}\""))
      sleep(1)
    end
  end

  # Write out Chef environment file from Demo Settings configuration json file
  config.trigger.before [:up, :reload, :provision] do |trigger|
    trigger.name = 'Creating environment file...'
    trigger.ruby do
      demo_settings = JSON.parse(File.read(demo_settings_file))
      environment_file_content = [
          'name "vm"',
          'description "Configuration file for the Kukla Demo VM"',
          "default_attributes(#{demo_settings})"
      ]  
      File.open(environment_file, "w+") do |file|
          file.puts(environment_file_content)
      end
      sleep(1)
    end
  end

  # SSH Key and VM Box
  config.ssh.insert_key = true
  config.vm.box = vm_settings['vm']['box']
  
  # Set the hostname and configure networking
  config.vm.define vm_settings['remote_machine']['name'] do |machine|
    machine.vm.network "private_network", ip: vm_settings['vm']['ip']
    machine.vm.hostname = vm_settings['vm']['url']
  end

  # Configure VM machine based on provider
  config.vm.provider "#{vm_settings['vm']['provider']}" do |machine|
    if vm_settings['vm']['provider'] == 'virtualbox'
      machine.gui = false
      config.vbguest.auto_update = false
      machine.customize [
        "modifyvm", :id,
          "--name", vm_settings['vm']['name'],
          "--memory", vm_settings['remote_machine']['ram'],
          "--cpus", vm_settings['remote_machine']['cpus'],
          "--vram", vm_settings['remote_machine']['vram'],
          "--vrde", vm_settings['remote_machine']['remote_display']
      ]
    else
      # VMWare-specific format
      machine.gui = true
      machine.vmx["memsize"] = vm_settings['remote_machine']['ram']
      machine.vmx["numvcpus"] = vm_settings['remote_machine']['cpus']
      machine.vmx["ethernet0.pcislotnumber"] = vm_settings['remote_machine']['eth0_pcislotnumber']
      machine.vmx["ethernet1.pcislotnumber"] = vm_settings['remote_machine']['eth1_pcislotnumber']
    end
  end

  # Run Chef check provisioner
  config.vm.provision "#{vm_settings['provisioner']['type']}" do |chef|
    chef.nodes_path = "#{vm_settings['provisioner']['nodes_path']}"
    chef.environments_path = "#{vm_settings['provisioner']['environments_path']}"
    chef.roles_path = "#{vm_settings['provisioner']['roles_path']}"
    chef.cookbooks_path = "#{vm_settings['provisioner']['cookbooks_path']}"  

    # Environment
    chef.environment = 'vm'

    # Roles
    chef.add_role "base"
    chef.add_role "infrastructure"
    chef.add_role "application"

    # Accept Chef License
    chef.arguments = '--chef-license accept'
  end
end
