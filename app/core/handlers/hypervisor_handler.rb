require_relative 'elasticsearch_handler'

class HypervisorHandler
	@hypervisor = Hypervisor.value

	def HypervisorHandler.configure_network(machine)
		case @hypervisor
		when 'virtualbox'
			machine.vm.network 'private_network', ip: Config.value('vm/ip')
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
			machine.vmx['displayName'] = Config.value('vm/name')
			machine.vmx['memsize'] = Config.value('remote_machine/memory')
			machine.vmx['numvcpus'] = Config.value('remote_machine/cpus')
		end
	end

	def HypervisorHandler.configure_search(config)
		case @hypervisor
		when 'virtualbox'
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

				unless Elasticsearch.is_running?
					config.trigger.before :destroy do |trigger|
						trigger.name =
							"Wiping Elasticsearch indices for #{DemoStructure.base_url}"
						trigger.ruby { ElasticsearchHandler.wipe(DemoStructure.base_url) }
					end
				end
			end
		end
	end
end
