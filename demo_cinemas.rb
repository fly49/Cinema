require_relative 'lib/netflix'
require_relative 'lib/theatre'

netflix = Cinema::Netflix.new('movies.txt')
theatre = Cinema::Theatre.new('movies.txt')

# netflix.show("Finding Nemo")
netflix.pay(25)
# netflix.show(genre: 'Drama', period: :classic, country: 'France')
# netflix.show { |movie| movie.genre.include?('Action') && movie.year > 2000 && movie.rating > 8.5 }
netflix.define_filter(:old) { |movie| movie.year < 1960 }
netflix.define_filter(:actions) { |movie| movie.genre.include?('Action') }
# puts netflix.filters
netflix.show(old: true)
netflix.define_filter(:custom_year) { |movie, year| movie.year > year }
netflix.show(custom_year: 2010)
# puts netflix.account
netflix.define_filter(:new_custom_year, from: :custom_year, arg: 2014)
netflix.show(new_custom_year: true)

# theatre.show(:special)
# puts theatre.when?('The Kid')