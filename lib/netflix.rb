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
    end

    def pay(amount)
      @account += amount
    end

    def how_much?(name)
      PRICE[find(name).class.name.split('::').last.to_sym]
    end

    def define_filter(name, from: nil, arg: nil, &block)
      if from && arg
        raise('Filter doesn\'t exist!') unless filters[from]
        filters.store(name,proc { |movie| filters[from].call(movie,arg) })
      else
        filters.store(name,block)
      end
    end
    
    

    def show(hash = {})
      movie =
        if block_given?
          @database.select { |m| yield m }
        else
          filter(hash)
        end
        .max_by { |m| m.rating * rand }
      withdraw_money(movie.title)
      super movie
    end
  
    private
    
    def filter(hash)
      hash.reduce(@database) do |f_data, (key, val)|
        sel_block = filter_select_block(key,val)
        f_data.select(&sel_block) if val
      end
    end
    
    def filter_select_block(key,val)
      if filters[key]
        proc { |m| filters[key].call(m,val) }
      elsif @database[0].respond_to?(key)
        proc { |film| Array(film.send(key)).any? { |i| val === i } }
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