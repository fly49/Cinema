require 'csv'
require 'yaml'
require 'themoviedb-api'

class GetTmdbData
  
  def initialize
    Tmdb::Api.key(File.open('config/key.yml', &:readline))
    @config = Tmdb::Configuration.get
  end
  
  def fetch_one(imdb_id)
    movie = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id', language: 'ru').first
    poster_path = @config.images.base_url + @config.images.poster_sizes[1] + movie.poster_path
    [movie.original_title, movie.title, poster_path]
  end
  
  def fetch_all(movies)
    if File.exist?('tmdb_base.yml')
      puts 'Data from Tmdb has already been gotten'
      return
    end
    @tmdb_base = movies.each_with_object({})  do |movie, hash|
      id = movie.link.match(%r{tt\d{5,7}}).to_s
      sleep(0.25)
      hash[id] = fetch_one(id)
    end
    return self
  end
  
  def save(path)
    File.open(File.join(path), 'w') do |f|
      f.write(@tmdb_base.to_yaml)
    end
  end
end