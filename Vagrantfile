# Pull in configuration
require 'json'
settings = JSON.parse(File.read(File.dirname(File.expand_path(__FILE__)) + '/config.json'))

# Start VM Setup
Vagrant.configure("2") do |config|

  # Plugin check (VMWare Fusion and Virtualbox will want different Vagrant plugins)
  plugins = settings['vagrant']['plugins']['all']
  if settings['vm']['provider'] == 'virtualbox'
    plugins.push(*settings['vagrant']['plugins']['virtualbox'])
  else
    plugins.push(*settings['vagrant']['plugins']['vmware_desktop'])
  end
  config.trigger.before :up do |trigger|
    trigger.info = "Checking for required plugins..."
    plugins.each do |plugin|
      unless Vagrant.has_plugin?("#{plugin}")
        system("vagrant plugin install #{plugin}", :chdir=>"/tmp") || exit!
      end
    end
  end

  # SSH Key and VM Box
  config.ssh.insert_key = true
  config.vm.box = settings['vm']['box']

  # Set the hostname and configure networking
  config.vm.define settings['remote_machine']['name'] do |machine|
    machine.vm.network "private_network", ip: settings['vm']['ip']
    machine.vm.hostname = settings['vm']['url']
  end

  # Configure VM machine based on provider
  config.vm.provider "#{settings['vm']['provider']}" do |machine|
    machine.gui = false
    if settings['vm']['provider'] == 'virtualbox'
      config.vbguest.auto_update = false
      machine.customize [
        "modifyvm", :id,
          "--name", settings['vm']['name'],
          "--memory", settings['remote_machine']['ram'],
          "--cpus", settings['remote_machine']['cpus'],
          "--vram", settings['remote_machine']['vram'],
          "--vrde", settings['remote_machine']['remote_display']
      ]
    else
      # VMWare-specific format
      machine.vmx["memsize"] = settings['remote_machine']['ram']
      machine.vmx["numvcpus"] = settings['remote_machine']['cpus']
    end
  end

  # Run Chef check provisioner
  config.vm.provision "#{settings['provisioner']['type']}" do |chef|
    chef.nodes_path = "#{settings['provisioner']['nodes_path']}"
    chef.environments_path = "#{settings['provisioner']['environments_path']}"
    chef.roles_path = "#{settings['provisioner']['roles_path']}"
    chef.cookbooks_path = "#{settings['provisioner']['cookbooks_path']}"  

    # Roles
    chef.add_role "base"
    chef.add_role "infrastructure"
    chef.add_role "application"

    # Accept Chef License
    chef.arguments = '--chef-license accept'
  end
end
