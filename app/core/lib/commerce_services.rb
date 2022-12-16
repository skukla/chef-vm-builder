require_relative 'config'

class CommerceServices
  class << self
    attr_reader :setting_path, :required_fields
  end
  @setting_path = 'application/authentication'
  @required_fields = %w[production_api_key]

  def CommerceServices.credentials_missing?
    setting = Config.value(@setting_path)
    return unless setting.key?('commerce_services')
    return true if (@required_fields - setting['commerce_services'].keys).any?
    false
  end
end
