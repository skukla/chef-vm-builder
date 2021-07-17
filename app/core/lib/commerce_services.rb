require_relative 'config'

class CommerceServices
	class << self
		attr_reader :setting_path, :required_fields, :required_modules
	end
	@setting_path = 'application/authentication/commerce_services'
	@required_fields = %w[production_api_key project_id data_space_id]
	@required_modules = %w[magento/product-recommendations magento/live-search]

	def CommerceServices.credentials_missing?
		setting = Config.setting(@setting_path)
		return nil if setting.nil?
		return true if setting.empty?

		setting.select do |key, value|
			(@required_fields.include?(key) && value.to_s.empty?)
		end.any?
	end
end
