#
# Vagrantfile
#
# This file:
#   1. Reads VM settings from config/vm.json for use in VM setup
#   2. Reads demo settings from config/demo.json for use as Chef attributes
#   3. Converts demo settings to a ruby hash and writes out /environments/vb.rb for Chef
#   4. Checks for particular Vagrant plugins based on provider
#   5. Configures VM settings based on provider
#   6. Runs the Chef provisioner
#   7. Updates permissions and clears cache
#   8. Saves the settings so they're persisted inside the VM on the next run
#
# Copyright 2020, Steve Kukla, All Rights Reserved.
require "json"

# Clear the screen
system ("clear")

# Configuration file list
config_file = File.dirname(File.expand_path(__FILE__)) + "/config.json"
infra_settings_file = File.dirname(File.expand_path(__FILE__)) + "/data_bags/init/settings.json"
environment_file = File.dirname(File.expand_path(__FILE__)) + "/environments/vm.rb"

# Read the configuration json file
config_file_content = File.read(config_file)
settings = JSON.parse(config_file_content)

# Start VM Setup
Vagrant.configure("2") do |config|
  
  # Plugin check (VMWare Fusion and Virtualbox will want different Vagrant plugins)
  config.trigger.before :up do |trigger|
    trigger.name = "Checking for required plugins..."
    trigger.ruby do
      plugins = settings["vagrant"]["plugins"]["all"]
      if settings["vagrant"]["provider"] == "virtualbox"
        plugins.push(*settings["vagrant"]["plugins"]["virtualbox"])
      else
        plugins.push(*settings["vagrant"]["plugins"]["vmware"])
      end
      plugins.each do |plugin|
        unless Vagrant.has_plugin?("#{plugin}")
          system("vagrant plugin install #{plugin}", :chdir=>"/tmp") || exit!
        end
      end
      sleep(1)
    end
  end

  # Write out chef environment file from configuration
  config.trigger.before [:up, :reload, :provision] do |trigger|
    trigger.name = "Creating environment file..."
    trigger.ruby do
      environment_file_content = [
          'name "vm"',
          'description "Configuration file for the Kukla Demo VM"',
          "default_attributes(#{settings})"
      ]  
      File.open(environment_file, "w+") do |file|
          file.puts(environment_file_content)
      end
      sleep(1)
    end
  end

  # SSH/Password access and VM Box
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  
  config.vm.box = settings["remote_machine"]["box"]
  
  # Set the hostname and configure networking
  config.vm.define settings["remote_machine"]["name"] do |machine|
    machine.vm.network "private_network", ip: settings["vm"]["ip"]
    machine.vm.hostname = settings["vm"]["url"]
  end

  # Configure VM machine based on provider
  config.vm.provider "#{settings["vagrant"]["provider"]}" do |machine|
    if settings["vagrant"]["provider"] == "virtualbox"
      machine.gui = settings["remote_machine"]["provider"]["virtualbox"]["gui"]
      machine.linked_clone = settings["remote_machine"]["provider"]["virtualbox"]["linked_clones"]
      machine.default_nic_type = settings["remote_machine"]["provider"]["virtualbox"]["default_nic_type"]
      config.vbguest.auto_update = settings["remote_machine"]["provider"]["virtualbox"]["auto_update"]
      machine.customize [
        "modifyvm", :id,
          "--name", settings["vm"]["name"],
          "--memory", settings["remote_machine"]["ram"],
          "--cpus", settings["remote_machine"]["cpus"],
          "--vram", settings["remote_machine"]["vram"],
          "--vrde", settings["remote_machine"]["provider"]["virtualbox"]["remote_display"]
          
      ]
    # VMWare-specific settings
    elsif settings["vagrant"]["provider"].include?("vmware")
      machine.gui = settings["remote_machine"]["provider"]["vmware"]["gui"]
      machine.linked_clone = settings["remote_machine"]["provider"]["vmware"]["linked_clones"]
      machine.vmx["memsize"] = settings["remote_machine"]["ram"]
      machine.vmx["numvcpus"] = settings["remote_machine"]["cpus"]
      machine.vmx["ethernet0.pcislotnumber"] = settings["remote_machine"]["provider"]["vmware"]["eth0_pcislotnumber"]
      machine.vmx["ethernet1.pcislotnumber"] = settings["remote_machine"]["provider"]["vmware"]["eth1_pcislotnumber"]
    end
  end

  # Run Chef check provisioner
  config.vm.provision "#{settings["provisioner"]["type"]}" do |chef|
    chef.nodes_path = "#{settings["provisioner"]["nodes_path"]}"
    chef.data_bags_path = "#{settings["provisioner"]["data_bags_path"]}"
    chef.environments_path = "#{settings["provisioner"]["environments_path"]}"
    chef.roles_path = "#{settings["provisioner"]["roles_path"]}"
    chef.cookbooks_path = "#{settings["provisioner"]["cookbooks_path"]}"  

    # Environment
    chef.environment = "vm"

    # Roles
    chef.add_role "base"
    chef.add_role "infrastructure"
    chef.add_role "application"

    # Accept Chef License
    chef.arguments = "--chef-license accept"
  end
  
  # Always set final file ownership
  config.trigger.after [:up, :reload, :provision] do |trigger|
    trigger.name = "Setting application permissions..."
    trigger.run_remote = {inline: "bash -c 'source /home/#{settings["remote_machine"]["user"]}/cli/commands.sh && own-trigger'"}
  end

  # Clear config and full_page cache if new code is downloaded or installed
  if settings["application"]["installation"]["options"]["download"]["base_code"] or settings["application"]["installation"]["options"]["download"]["b2b_code"] or settings["application"]["installation"]["options"]["download"]["custom_modules"] or settings["application"]["installation"]["options"]["sample_data"] or settings["application"]["installation"]["options"]["deploy_mode"]["apply"] or settings["application"]["installation"]["options"]["install"]
    config.trigger.after [:up, :reload, :provision] do |trigger|
      trigger.name = "Clearing cache"
      trigger.run_remote = {inline: "bash -c 'source /home/#{settings["remote_machine"]["user"]}/cli/commands.sh && cache-trigger'"}
    end
  end

  # Save the configured infrastructure settings into a reference file
  config.trigger.after [:up, :reload, :provision] do |trigger|
    trigger.name = "Saving infrastructure settings..."
    trigger.ruby do
      File.open(infra_settings_file, "w+") do |file|
        file.puts(config_file_content)
      end
    end
  end
end
