class Color
	class << self
		attr_reader :value
	end
	@value = {
		bold: `tput bold`,
		reg: `tput sgr0`,
		green: `tput setaf 2`,
		magenta: `tput setaf 5`,
		cyan: `tput setaf 6`,
	}
end
