require_relative 'config'

class Provisioner
  def Provisioner.type
    return Config.provisioner_type unless Config.provisioner_type.nil?

    'chef_zero'
  end

  def Provisioner.version
    return Config.provisioner_version unless Config.provisioner_version.nil?

    '18.1.0'
  end
end
