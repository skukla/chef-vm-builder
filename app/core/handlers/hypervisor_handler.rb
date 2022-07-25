require_relative 'elasticsearch_handler'
require_relative 'hosts_handler'
require_relative 'entry_handler'
require_relative 'file_handler'

class HypervisorHandler
	@hypervisor = Hypervisor.value

	def HypervisorHandler.configure_box_and_ssh(config)
		config.ssh.insert_key = false
		config.ssh.forward_agent = true
		config.ssh.username = 'vagrant'
		config.ssh.password = 'vagrant'
		config.vm.box = Hypervisor.base_box
	end

	def HypervisorHandler.configure_network(machine)
		case
		when @hypervisor.include?('virtualbox')
			machine.vm.network 'private_network', type: 'dhcp'
		when @hypervisor.include?('vmware')
			machine.vm.network 'private_network'
		end
	end

	def HypervisorHandler.customize_vm(machine)
		machine.gui = Hypervisor.gui
		machine.linked_clone = true

		case
		when @hypervisor.include?('virtualbox')
			machine.default_nic_type = '82543GC'
			machine.customize [
					'modifyvm',
					:id,
					'--name',
					Config.value('vm/name'),
					'--memory',
					Config.value('remote_machine/memory'),
					'--cpus',
					Config.value('remote_machine/cpus'),
					'--vram',
					'16',
					'--vrde',
					'off',
			                  ]
		when @hypervisor.include?('vmware')
			machine.allowlist_verified = true
			machine.vmx['displayName'] = Config.value('vm/name')
			machine.vmx['memsize'] = Config.value('remote_machine/memory')
			machine.vmx['numvcpus'] = Config.value('remote_machine/cpus')
		end
	end

	def HypervisorHandler.copy_items(config)
		config.trigger.before %i[up reload provision] do |trigger|
			trigger.name = 'Copying items to VM and creating environment file'
			trigger.ruby do
				EntryHandler.copy_entries
				EntryHandler.clean_up_hidden_files
				FileHandler.create_environment_file
			end
		end
	end

	def HypervisorHandler.configure_search(config)
		case @hypervisor
		when 'virtualbox'
			if Elasticsearch.is_requested?
				if Elasticsearch.is_missing?
					config.trigger.before %i[up reload provision] do |trigger|
						trigger.name = 'Installing Elasticsearch on your machine'
						trigger.ruby { ElasticsearchHandler.install }
					end
				end

				unless Elasticsearch.is_running?
					config.trigger.before %i[up reload provision] do |trigger|
						trigger.name = 'Starting Elasticsearch'
						trigger.ruby { ElasticsearchHandler.start }
					end
				end

				if Config.wipe_search_engine?
					config.trigger.before %i[up reload provision] do |trigger|
						trigger.name = 'Wiping Elasticsearch'
						trigger.ruby { ElasticsearchHandler.wipe(DemoStructure.base_url) }
					end
				end
			end

			if !Elasticsearch.is_missing? && Elasticsearch.is_running?
				config.trigger.after :destroy do |trigger|
					trigger.name =
						"Wiping Elasticsearch indices for #{DemoStructure.base_url}"
					trigger.ruby { ElasticsearchHandler.wipe(DemoStructure.base_url) }
				end
			end
		end
	end

	def HypervisorHandler.configure_hosts(config)
		config.vm.hostname = DemoStructure.base_url
		HostsHandler.manage_hosts(config)
	end

	def HypervisorHandler.vm_clean_up(config)
		config.trigger.after :destroy do |trigger|
			trigger.name = 'Cleaning up VMs'
			trigger.ruby { EntryHandler.remove_machine_dirs }
		end
	end
end
