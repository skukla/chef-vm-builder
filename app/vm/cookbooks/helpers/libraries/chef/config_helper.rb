class ConfigHelper < Config
	def ConfigHelper.json
		Chef.node
	end
end
