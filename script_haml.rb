require 'haml'
require_relative 'lib/netflix'

template = File.read('page.haml')
haml_engine = Haml::Engine.new(template)
output = haml_engine.render(Object.new, :netflix => Cinema::Netflix.new('movies.txt'))

html_file = File.new('page.html')
File.open(html_file, 'w') do |f|
  f.write(output)
end