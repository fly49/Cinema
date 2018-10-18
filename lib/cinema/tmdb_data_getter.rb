require 'csv'
require 'yaml'
require 'themoviedb-api'

module Cinema  
  class TmdbDataGetter
    class << self
    
      def fetch_all(movies)
        return if File.exist?('data/tmdb_base.yml')
        configure
        @tmdb_base = movies.each_with_object({}) do |movie, hash|
          id = movie.link.match(/tt\d{5,7}/).to_s
          sleep(0.25)
          hash[id] = fetch_one(id)
        end
        self
      end
    
      def save(path)
        File.write(path,@tmdb_base.to_yaml)
      end
      
      private
      
      def fetch_one(imdb_id)
        movie = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id', language: 'ru').first
        poster_path = @config.images.base_url + @config.images.poster_sizes[1] + movie.poster_path
        [movie.original_title, movie.title, poster_path]
      end
      
      def configure
        Tmdb::Api.key(File.open('config/key.yml', &:readline))
        @config = Tmdb::Configuration.get
      end
    end
  end
end