require_relative 'config'

class CommerceServices
	class << self
		attr_reader :setting_path, :required_fields, :required_modules
	end
	@setting_path = 'application/authentication/commerce_services'
	@required_fields = %w[production_api_key project_id data_space_id]
	@required_modules = %w[
		magento/product-recommendations
		magento/live-search
		magento/module-page-builder-product-recommendations
		magento/module-visual-product-recommendations
	]

	def CommerceServices.credentials_missing?
		setting = Config.value(@setting_path)
		return true if setting.nil? || setting.empty?

		(@required_fields - setting.keys).any?
	end
end
