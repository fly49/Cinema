require 'haml'
require 'fileutils'
require_relative 'lib/netflix'

module Cinema
  class NetflixRenderer
    attr_reader :template
    
    def initialize(haml_template)
      @template = File.read(haml_template)
    end
    
    def render_to(file_name,path=nil)
      haml_engine = Haml::Engine.new(template)
      output = haml_engine.render(Object.new,
                                  :netflix => Netflix.new('movies.txt'))
      unless path.nil?
        FileUtils.mkdir_p(path) unless File.exist?(path)
      else
        path = File.dirname(__FILE__)
      end
      File.open(File.join(path, file_name), 'w') do |f|
        f.write(output)
      end
    end
  end
end

Cinema::NetflixRenderer.new('page.haml').render_to("page.html")
