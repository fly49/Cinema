require 'csv'
require 'date'
require_relative 'movie'
require_relative 'cashbox'

module Cinema
  # MovieCollection contains information about top-250 imdb movies and allow to choose specific ones in different ways.
  class MovieCollection
    include Enumerable
    attr_reader :genres, :img_base
    TABLE = %I[link title year country date genre duration rating director cast].freeze

    def initialize(name)
      raise("File doesn't exist!") unless File.file?(name)
      @database = CSV.read(name, col_sep: '|', headers: TABLE).map { |a| Movie.create(a.to_hash, self) }
      if File.exist?('tmdb_base.yml')
        @img_base = YAML::parse( File.open( 'tmdb_base.yml' ) ).transform
      end
      @genres = @database.flat_map(&:genre).uniq
    end

    def each(&block)
      @database.each(&block)
    end

    def all
      @database
    end

    def find(name)
      @database.find { |f| f.title == name } || raise('Movie not found!')
    end

    def show(movie)
      start_at = Time.now.strftime('%H:%M')
      end_at = (Time.now + movie.duration * 60).strftime('%H:%M')
      puts "Now showing: «#{movie.title}» #{start_at} - #{end_at}"
      movie
    end

    def sort_by(param)
      raise('Wrong param!') unless @database[0].respond_to?(param)
      @database.sort_by(&param).first(5)
    end

    def filter(hash)
      hash.reduce(@database) do |f_data, (key, val)|
        raise('Wrong param!') unless @database[0].respond_to?(key) || key.to_s.split('_').first == 'exclude'
        if key.to_s.split('_').first == 'exclude'
          param = key.to_s.split('_').last
          f_data.reject { |film| film.send(param) == val }
        elsif val.is_a? Array
          f_data.select { |film| (val & film.send(key)) == val }
        else
          f_data.select { |film| Array(film.send(key)).any? { |i| val === i } }
        end
      end
    end

    def stats(param)
      raise('Wrong param!') unless @database[0].respond_to?(param)
      @database.flat_map(&param)
               .each_with_object(Hash.new(0)) { |d, hash| hash[d] += 1 }
               .sort_by { |_k,v| v }.reverse.to_h
    end
  end
end