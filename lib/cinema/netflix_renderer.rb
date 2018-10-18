require 'haml'

module Cinema
  class NetflixRenderer
    attr_reader :template

    def initialize(netflix)
      @template = File.read('data/page.haml')
      @netflix = netflix
    end

    def render_to(file_name)
      haml_engine = Haml::Engine.new(template)
      output = haml_engine.render(Object.new, netflix: @netflix)
      File.write(file_name, output)
    end
  end
end