require 'csv'
require 'yaml'
require 'themoviedb-api'

class GetTmdbData
  def get
    if File.exist?('tmdb_base.yml')
      puts 'Data has already been gotten'
      return
    end
    
    Tmdb::Api.key("1f0a1ffab16aa952b101497e65a09e46")
    config = Tmdb::Configuration.get
    
    base = CSV.read('movies.txt', col_sep: '|').map { |a| Hash[a[1],a[0].match(%r{tt\d{5,7}}).to_s] }
    
    tmdb_base = base.each.with_index.each_with_object({})  do |(v, i), hash|
      rus_title, id = v.first
      if i % 40 == 0 
        sleep 10
      end
      movie = Tmdb::Find.movie(id, external_source: 'imdb_id', language: 'ru').first
      poster_path = config.images.base_url + config.images.poster_sizes[1] + movie.poster_path
      hash[id] = [rus_title, movie.title, poster_path]
    end
    File.open(File.join("tmdb_base.yml"), 'w') do |f|
      f.write(tmdb_base.to_yaml)
    end
  end
end