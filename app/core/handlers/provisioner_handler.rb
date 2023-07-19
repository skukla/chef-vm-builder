require_relative '../lib/provisioner'

class ProvisionerHandler
  def ProvisionerHandler.install_prebuild_packages(config)
    config.vm.provision 'shell',
                        name: 'Installing pre-build packages',
                        path: 'scripts/install_prebuild_packages.sh'
  end

  def ProvisionerHandler.run_chef(config)
    config.vm.provision Provisioner.type do |chef|
      chef.version = Provisioner.version
      chef.install = Provisioner.install?
      chef.nodes_path = 'nodes'
      chef.environments_path = 'environments'
      chef.roles_path = 'roles'
      chef.cookbooks_path = 'cookbooks'
      chef.environment = 'vm'
      chef.add_role 'main'
      chef.arguments = '--chef-license accept'
    end
  end
end
