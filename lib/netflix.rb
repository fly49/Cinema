require_relative 'movie_collection'

module Cinema
  class Netflix < MovieCollection
    extend Cashbox
    attr_reader :account, :filters
    PRICE = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }.freeze

    def initialize(name)
      super
      @account = 0.0
      @filters = {}
      @database[0].attributes.each do |key,_v|
        self.class.send(:define_method,"by_#{key}") {SpecialHash.new(self,key)}
      end
    end
    
    class SpecialHash
      attr_reader :hash, :by
      
      def initialize(database,param)
        @by = param
        @hash = database.all.each_with_object({}) do |movie, hash|
          hash[movie.title] = movie.send(param)
        end
        database.genres.each do |genre|
          self.class.send(:define_method,"#{genre.downcase}") do
            @hash.select { |k,v| v.include?(genre) }.map(&:first)
          end
        end
      end
      
      def method_missing(name)
        if @by == :country
          country = name.to_s.length > 3 ? name.to_s.capitalize : name.to_s.upcase
          p country
          @hash.select { |_k,v| v.include?(country) }.map(&:first)
        end
      end

      
    end

    def pay(amount)
      @account += amount
    end

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

    def show(**filters, &block)
      movie = filter(filters).select(&block)
                             .max_by { |m| m.rating * rand }
      withdraw_money(movie.title)
      super movie
    end

    private
    
    

    def filter(**filters)
      filters.reduce(@database) do |f_data, (key, val)|
        f_data.select { |movie| matches_filter?(movie, key, val) }
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

    def withdraw_money(movie_title)
      movie_price = how_much?(movie_title)
      raise('Not enough funds!') if @account < movie_price
      @account -= movie_price
      Netflix.add_money(movie_price)
    end
  end
end