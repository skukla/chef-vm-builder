class App
  class << self
    attr_reader :root
  end
  @root = "/#{File.join(Pathname.new(__dir__).each_filename.to_a[0...-3])}"
end
