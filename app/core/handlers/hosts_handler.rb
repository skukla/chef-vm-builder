require_relative '../lib/remote_machine'
require_relative '../lib/info_message'

class HostsHandler
	@trigger_name = 'Managing hosts in hosts file'

	def HostsHandler.refresh_trigger(trigger)
		trigger.ruby do |_env, vm|
			print InfoMsg.output(
					'Refreshing host entries in /etc/hosts (Your password may be necessary)...',
			      )
			FileHandler.update_hosts_file(vm, :remove)
			FileHandler.update_hosts_file(vm, :add)
		end
	end

	def HostsHandler.delete_trigger(trigger)
		trigger.ruby do |_env, vm|
			print InfoMsg.output(
					'Removing host entries from /etc/hosts (Your password may be necessary)...',
			      )
			FileHandler.update_hosts_file(vm, :remove)
		end
	end

	def HostsHandler.manage_hosts(config)
		config.trigger.before %i[reload resume provision] do |trigger|
			trigger.name = @trigger_name
			refresh_trigger(trigger)
		end

		config.trigger.before %i[halt suspend destroy] do |trigger|
			trigger.name = @trigger_name
			delete_trigger(trigger)
		end

		config.trigger.after :up do |trigger|
			trigger.name = @trigger_name
			refresh_trigger(trigger)
		end
	end
end
