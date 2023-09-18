require_relative 'app'
require_relative 'demo_structure'
require_relative 'entry'

class Certificate
  def Certificate.exists?
    Entry
      .files_from('app/certificate')
      .include?(
        File.join(App.root, 'app/certificate', "#{DemoStructure.base_url}.crt"),
      )
  end
end
