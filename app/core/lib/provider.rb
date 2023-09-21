require_relative 'config'
require_relative 'guest_machine'

class Provider
  def Provider.value
    Config.provider
  end

  def Provider.list
    %w[virtualbox vmware_desktop]
  end

  def Provider.plugins
    case
    when value.include?('virtualbox')
    when value.include?('vmware')
      %w[vagrant-vmware-desktop]
    end
  end

  def Provider.gui
    return Config.gui unless Config.gui.nil?

    case
    when value.include?('virtualbox')
      false
    when value.include?('vmware')
      true
    end
  end

  def Provider.base_box
    boxes = {
      'intel' => 'bento/ubuntu-22.04',
      'arm' => 'bento/ubuntu-22.04-arm64',
    }

    return Config.base_box unless Config.base_box.nil?

    base_box = boxes['intel'] if GuestMachine.is_intel?
    base_box = boxes['arm'] unless GuestMachine.is_intel?

    base_box
  end

  def Provider.elasticsearch_requested?
    unless Config.elasticsearch_requested?.nil?
      return Config.elasticsearch_requested?
    end

    case
    when value.include?('virtualbox')
      true
    when value.include?('vmware')
      false
    end
  end
end
