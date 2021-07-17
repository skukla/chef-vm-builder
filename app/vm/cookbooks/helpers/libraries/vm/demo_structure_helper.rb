class DemoStructureHelper < DemoStructure
	def DemoStructureHelper.json
		@@data[:result] = ConfigHelper.setting('custom_demo/structure/websites')
		self
	end
end
