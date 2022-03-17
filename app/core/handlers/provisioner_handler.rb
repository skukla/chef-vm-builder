class ProvisionerHandler
	def ProvisionerHandler.install_prebuild_packages(config)
		config.vm.provision 'shell',
		                    name: 'Installing pre-build packages',
		                    path: 'scripts/install_prebuild_packages.sh'
	end

	def ProvisionerHandler.run_chef(config)
		config.vm.provision 'chef_zero' do |chef|
			chef.version = '16.13.16'
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
