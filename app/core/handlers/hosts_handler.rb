require_relative '../lib/remote_machine'
require_relative '../lib/info_message'

class HostsHandler
	def HostsHandler.add_trigger(trigger)
		trigger.name = 'Managing hosts in hosts file'
		trigger.ruby do |_env, vm|
			if FileHandler.vm_in_host_file?(vm.id)
				print InfoMsg.output('Host entries found, skipping...')
			end

			unless FileHandler.vm_in_host_file?(vm.id)
				print InfoMsg.output(
						'Adding host entries to /etc/hosts (Your password may be necessary)...',
				      )
				FileHandler.update_hosts_file(vm, :add)
			end
		end
	end

	def HostsHandler.delete_trigger(trigger)
		trigger.name = 'Removing hosts from hosts file'
		trigger.ruby do |_env, vm|
			print InfoMsg.output(
					'Removing host entries from /etc/hosts (Your password may be necessary)...',
			      )
			FileHandler.update_hosts_file(vm, :remove)
		end
	end

	def HostsHandler.manage_hosts(config)
		config.trigger.before %i[resume provision] do |trigger|
			add_trigger(trigger)
		end

		config.trigger.before %i[destroy reload halt suspend] do |trigger|
			delete_trigger(trigger)
		end

		config.trigger.after %i[up reload] do |trigger|
			add_trigger(trigger)
		end
	end
end
