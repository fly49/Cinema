require 'csv'
require 'yaml'
require 'themoviedb-api'

module Cinema  
  class TmdbDataGetter
    class << self
    
      def fetch_all(ids)
        return if File.exist?('data/extra_data.yml')
        configure
        @tmdb_base = ids.each_with_object({}) do |id, hash|
          hash[id] = fetch_one(id)
          sleep(0.25)
        end
      end
      
      private
      
      def fetch_one(imdb_id)
        movie = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id', language: 'ru').first
        poster_path = @config.images.base_url + @config.images.poster_sizes[1] + movie.poster_path
        { 'rus_title' => movie.title, 'img_url' => poster_path }
      end
      
      def configure
        Tmdb::Api.key(File.open('config/key.yml', &:readline))
        @config = Tmdb::Configuration.get
      end
    end
  end
end
