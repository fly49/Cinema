require_relative 'lib/netflix'
require_relative 'lib/theatre'
require 'yaml'
require 'themoviedb-api'

netflix = Netflix.new('movies.txt')
theatre = Theatre.new('movies.txt')

# netflix.show("Finding Nemo")
# netflix.pay(25)
# netflix.show(genre: 'Drama', period: :classic, country: 'France')
# puts netflix.account

#theatre.show(:special)
#puts theatre.when?('The Kid')

#yaml = YAML.load_file("movies.txt")
#p yaml

Tmdb::Api.key("1f0a1ffab16aa952b101497e65a09e46")
netflix.all.first.link.match(%r{tt\d{5,7}})
movie = Tmdb::Find.movie(netflix.all.first.link.match(%r{tt\d{5,7}}), external_source: 'imdb_id', language: 'ru')
p movie