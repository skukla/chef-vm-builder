require_relative 'elasticsearch_handler'

class HypervisorHandler
	@hypervisor = Hypervisor.value

	def HypervisorHandler.configure_network(machine)
		case @hypervisor
		when 'virtualbox'
			machine.vm.network 'private_network', type: 'dhcp'
		when 'vmware_fusion'
			machine.vm.network 'private_network'
		end
	end

	def HypervisorHandler.customize_vm(machine)
		case @hypervisor
		when 'virtualbox'
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
		when 'vmware_fusion'
			machine.allowlist_verified = true
			machine.vmx['displayName'] = Config.value('vm/name')
			machine.vmx['memsize'] = Config.value('remote_machine/memory')
			machine.vmx['numvcpus'] = Config.value('remote_machine/cpus')
		end
	end

	def HypervisorHandler.configure_search(config)
		case @hypervisor
		when 'virtualbox'
			return if Elasticsearch.is_missing? || !Elasticsearch.is_running?

			if Config.elasticsearch_requested? || Config.search_engine_type.nil?
				config.trigger.before %i[up reload provision] do |trigger|
					trigger.name = 'Confirming Elasticsearch is present'
					trigger.ruby do
						ElasticsearchHandler.install
						ElasticsearchHandler.start
					end
				end

				if Config.wipe_search_engine?
					config.trigger.before %i[up reload provision] do |trigger|
						trigger.name = 'Wiping Elasticsearch'
						trigger.ruby { ElasticsearchHandler.wipe(DemoStructure.base_url) }
					end
				end

				config.trigger.before :destroy do |trigger|
					trigger.name =
						"Wiping Elasticsearch indices for #{DemoStructure.base_url}"
					trigger.ruby { ElasticsearchHandler.wipe(DemoStructure.base_url) }
				end
			end
		end
	end

	def HypervisorHandler.configure_hosts(config)
		config.vm.hostname = DemoStructure.base_url
		config.hostmanager.ip_resolver =
			proc do |vm, resolving_vm|
				if hostname = (vm.ssh_info && vm.ssh_info[:host])
					`vagrant ssh -c "hostname -I"`.split[1]
				end
			end
		config.hostmanager.enabled = true
		config.hostmanager.manage_host = true
		config.hostmanager.aliases = DemoStructure.additional_urls
	end

	def HypervisorHandler.copy_items(config)
		config.trigger.before %i[up reload provision] do |trigger|
			trigger.name = 'Copying items to VM and creating environment file'
			trigger.ruby do
				EntryHandler.copy_entries
				EntryHandler.clean_up_hidden_files
				EntryHandler.create_environment_file
			end
		end
	end
end
