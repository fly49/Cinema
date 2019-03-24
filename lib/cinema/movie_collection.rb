require 'csv'
require 'date'
require_relative 'movie'
require_relative 'cashbox'
require_relative 'tmdb_data_getter'
require_relative 'movie_budget_getter'

module Cinema
  # Contains information about top-250 imdb movies and allow to choose specific ones in different ways
  class MovieCollection
    
    include Enumerable  # for iteration over collection
    attr_reader :genres, :img_base, :budget_base
    TABLE = %I[link title year country date genre duration rating director cast].freeze

    # MovieCollection initializes via text file, that contains information about each film
    def initialize(name)
      raise("File doesn't exist!") unless File.file?(name)
      # Parse txt file into CSV-row objects
      csv_rows = CSV.read(name, col_sep: '|', headers: TABLE)
      # Parse IMDB ids to an array
      ids = csv_rows.map { |row| get_id(row) }
      # Get posters URLs and budgets
      parse_extra_data(ids) unless File.exist?('data/extra_data.yml')
      extra_data = YAML.parse(File.open('data/extra_data.yml')).transform
      # Create database based both on txt and extra data
      @database = csv_rows.map do |row|
        id = get_id(row)
        attr_hash = row.to_hash.merge(extra_data[id])
        Movie.create(attr_hash)
      end
      # Store list of genres
      @genres = @database.flat_map(&:genre).uniq
    end
    
    def parse_extra_data(ids)
      # Download posters URL's
      img_hash = TmdbDataGetter.fetch_all(ids)
      # Parse budgets
      budgets_hash = MovieBudgetGetter.get_all_budgets(ids)
      # Incorporate into extra data
      extra_data = img_hash.merge(budgets_hash) { |key, oldval, newval| oldval.merge(newval) }
      File.write('data/extra_data.yml',extra_data.to_yaml)
    end
    
    def get_id(csv_row)
      csv_row.field(:link).match(/tt\d{5,7}/).to_s
    end

    def each(&block)
      @database.each(&block)
    end

    def all
      @database
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
