class TextFormatter
  class << self
    attr_reader :value
  end
  @value = {
    bold: `tput bold`,
    reg: `tput sgr0`,
    red: `tput setaf 1`,
    green: `tput setaf 2`,
    magenta: `tput setaf 5`,
    cyan: `tput setaf 6`,
    enter_underline: `tput smul`,
    exit_underline: `tput rmul`,
  }
end
