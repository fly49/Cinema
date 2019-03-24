require_relative 'movie_collection'
require 'haml'
require 'damerau-levenshtein'

module Cinema
  class Netflix < MovieCollection
    extend Cashbox
    attr_reader :account, :filters
    PRICE = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }.freeze

    def initialize(name)
      super
      @account = 0.0
      @filters = {}
    end

    ### Chainable genre sorting
    # Example:
    # netflix.by_genre.comedy => get list of all comedies
    class GenreSorting
      def initialize(genres,collection)
        genres.each do |defined_genre|
          self.class.send(:define_method,defined_genre.downcase.to_s) do
            collection.filter(genre: defined_genre)
          end
        end
      end

      def method_missing(name)
        raise "Incorrect genre \"#{name}\"."
      end
    end
    def by_genre
      GenreSorting.new(@genres,self)
    end

    ### Chainable country sorting
    # Example:
    # netflix.by_country.usa => get list of all usa films
    class CountrySorting
      def initialize(collection)
        @collection = collection
      end

      def method_missing(name)
        country_name = name.to_s.length > 3 ? name.to_s.capitalize : name.to_s.upcase
        result = @collection.filter(country: country_name)
        result.empty? ? raise('No film from such country was found.') : result
      end
    end
    def by_country
      CountrySorting.new(self)
    end

    # Refill account
    def pay(amount)
      @account += amount
    end

    # Get movie price
    def how_much?(name)
      PRICE[find(name).class.name.split('::').last.to_sym]
    end

    def define_filter(name, from: nil, arg: nil, &block)
      if from && arg
        raise('Filter doesn\'t exist!') unless filters.key?(from)
        filters.store(name,proc { |movie| filters[from].call(movie,arg) })
      else
        filters.store(name,block)
      end
    end
    
    def filter(**filters)
      filters.reduce(@database) do |f_data, (key, val)|
        f_data.select { |movie| matches_filter?(movie, key, val) }
      end
    end
    
    def find(**filters, &block)
      filter(filters).select(&block).sort_by(&:rating).reverse
    end

    def show(title)
      movie = @database.find { |f| f.title == name }
      movie ? withdraw_money(movie) : suggest(title)
    end

    # Render IMDB list to HTML file
    def render_to(file_name)
      template = File.read('data/page.haml')
      haml_engine = Haml::Engine.new(template)
      output = haml_engine.render(Object.new, netflix: self)
      File.write(file_name, output)
    end

    private
    
    def suggest(mis_title)
      @database.map(&:title).min_by do |title|
        DamerauLevenshtein.distance(title, mis_title)
      end
    end

    def matches_filter?(movie,key,val)
      if filters[key]
        filters[key].call(movie,val)
      elsif @database[0].respond_to?(key)
        Array(movie.send(key)).any? { |i| val === i }
      else
        raise('Wrong param or filter name!')
      end
    end

    def withdraw_money(movie)
      movie_price = how_much?(movie.title)
      raise('Not enough funds!') if @account < movie_price
      @account -= movie_price
      Netflix.add_money(movie_price)
    end
  end
end
