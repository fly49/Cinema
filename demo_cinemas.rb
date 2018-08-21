require_relative 'lib/netflix_renderer'
require_relative 'lib/netflix'
require 'themoviedb-api'
require 'haml'

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
# p collection.all.first.rus_title

# p movie = Cinema::Movie.create(hash, collection)
# p Cinema::Movie.ancestors

# netflix = 
# theatre = Cinema::Theatre.new('movies.txt')

# puts netflix.by_genre.comedy
# puts '========'
# puts netflix.by_country.japan

# netflix.by_country.ussa

# netflix.show("Finding Nemo")
# netflix.pay(25)

# puts netflix.account
# netflix.define_filter(:new_custom_year, from: :custom_year, arg: 2014)
# netflix.show(new_custom_year: true)

# theatre.show(:special)
# puts theatre.when?('The Kid')

# Tmdb::Api.key("1f0a1ffab16aa952b101497e65a09e46")
# collection.all.first.link.match(%r{tt\d{5,7}})
# movie = Tmdb::Find.movie(collection.all.first.link.match(%r{tt\d{5,7}}), external_source: 'imdb_id', language: 'ru')
# p movie

# p "http://api.themoviedb.org/3/find/tt0111161?api_key=1f0a1ffab16aa952b101497e65a09e46&external_source=imdb_id&language=ru".
# match(/api.themoviedb.org/)

# p open('html_pages/page.html').read.class

netflix = Cinema::Netflix.new('movies.txt')
Cinema::NetflixRenderer.new(netflix).render_to('html_pages/page.html')