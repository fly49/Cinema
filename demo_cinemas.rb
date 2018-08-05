require_relative 'lib/netflix'
require_relative 'lib/theatre'
require_relative 'lib/movie'

# hash =
#    { link: 'http://imdb.com/title/tt0111161/?ref_=chttp_tt_1',
#      title: 'The Shawshank Redemption',
#      year: '1994',
#      country: 'USA',
#      date: '1994-10-14',
#      genre: 'Crime,Drama',
#      duration: '142 min',
#      rating: '9.3',
#      director: 'Frank Darabont',
#      cast: 'Tim Robbins,Morgan Freeman,Bob Gunton' }
      
# collection = Cinema::MovieCollection.new('movies.txt')

#p movie = Cinema::Movie.create(hash, collection)
#p Cinema::Movie.ancestors


netflix = Cinema::Netflix.new('movies.txt')

# theatre = Cinema::Theatre.new('movies.txt')

p netflix.by_genre.drama
p netflix.by_country.japan

# netflix.show("Finding Nemo")
# netflix.pay(25)
# netflix.show(genre: 'Drama', period: :classic, country: 'France')
# netflix.show { |movie| movie.genre.include?('Action') && movie.year > 2000 && movie.rating > 8.5 }
# netflix.define_filter(:old) { |movie| movie.year < 1960 }
# netflix.define_filter(:actions) { |movie| movie.genre.include?('Action') }
# puts netflix.filters
# netflix.show(old: true)
# netflix.define_filter(:custom_year) { |movie, year| movie.year > year }
# netflix.show(custom_year: 2010)
# puts netflix.account
# netflix.define_filter(:new_custom_year, from: :custom_year, arg: 2014)
# netflix.show(new_custom_year: true)

# theatre.show(:special)
# puts theatre.when?('The Kid')