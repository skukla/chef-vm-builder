require_relative 'elasticsearch_handler'
require_relative 'hosts_handler'
require_relative 'entry_handler'
require_relative 'file_handler'

class ProviderHandler
  @provider = Provider.value

  def ProviderHandler.configure_box_and_ssh(config)
    config.ssh.username = 'vagrant'
    config.ssh.password = 'vagrant'
    config.ssh.insert_key = false
    config.ssh.forward_agent = true
    config.vm.box = Provider.base_box
  end

  def ProviderHandler.configure_network(machine)
    case
    when @provider.include?('virtualbox')
      machine.vm.network 'private_network', type: 'dhcp'
    when @provider.include?('vmware')
      machine.vm.network 'private_network'
    end
  end

  def ProviderHandler.customize_vm(machine)
    machine.gui = Provider.gui
    machine.linked_clone = true

    case
    when @provider.include?('virtualbox')
      machine.default_nic_type = '82543GC'
      machine.customize [
                          'modifyvm',
                          :id,
                          '--name',
                          Config.vm_name,
                          '--memory',
                          Config.value('remote_machine/memory'),
                          '--cpus',
                          Config.value('remote_machine/cpus'),
                          '--vram',
                          '16',
                          '--vrde',
                          'off',
                        ]
    when @provider.include?('vmware')
      machine.allowlist_verified = true
      machine.vmx['displayName'] = Config.vm_name
      machine.vmx['memsize'] = Config.value('remote_machine/memory')
      machine.vmx['numvcpus'] = Config.value('remote_machine/cpus')
    end
  end

  def ProviderHandler.copy_items(config)
    config.trigger.before %i[up reload provision] do |trigger|
      trigger.name = 'Copying items to VM and creating environment file'
      trigger.ruby do
        EntryHandler.copy_entries
        EntryHandler.clean_up_hidden_files
        FileHandler.create_environment_file
      end
    end
  end

  def ProviderHandler.configure_search(config)
    case @provider
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

  def ProviderHandler.configure_hosts(config)
    config.vm.hostname = DemoStructure.base_url
    config.hostmanager.aliases = DemoStructure.additional_urls
    HostsHandler.manage_hosts(config)
  end

  def ProviderHandler.vm_clean_up(config)
    config.trigger.after :destroy do |trigger|
      trigger.name = 'Cleaning up VMs'
      trigger.ruby { EntryHandler.remove_machine_dirs }
    end
  end
end
