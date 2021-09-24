require_relative 'config'

class Composer
	class << self
		attr_reader :setting_path, :required_fields
	end
	@setting_path = 'application/authentication/composer'
	@required_fields = %w[public_key private_key github_token]

	def Composer.credentials_missing?
		setting = Config.value(@setting_path)
		return true if setting.to_s.empty?

		setting.select do |key, value|
			(@required_fields.include?(key) && value.to_s.empty?)
		end.any?
	end
end
