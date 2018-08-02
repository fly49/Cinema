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
        filters.store(name,proc { |movie| filters[from].call(movie,arg) })
      else
        filters.store(name,block)
      end
    end

    def show(hash = {})
      block_name, sent_val = hash.first
      movie =
        if block_given?
          @database.select { |m| yield m }
        elsif filters[block_name]
          @database.select { |m| filters[block_name].call(m,sent_val) } if sent_val
        else
          filter(hash)
        end
        .max_by { |m| m.rating * rand }
      movie_price = how_much?(movie.title)
      raise('Not enough funds!') if @account < movie_price
      @account -= movie_price
      Netflix.add_money(movie_price)
      super movie
    end
  end
end