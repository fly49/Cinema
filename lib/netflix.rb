require_relative 'movie_collection'

module Cinema
  class Netflix < MovieCollection
    extend Cashbox
    attr_reader :account
    PRICE = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }.freeze

    def initialize(name)
      super
      @account = 0.0
    end

    def pay(amount)
      @account += amount
    end

    def how_much?(name)
      PRICE[find(name).class.name.split('::').last.to_sym]
    end

    def show(hash)
      movie = filter(hash).max_by { |m| m.rating * rand }
      movie_price = how_much?(movie.title)
      raise('Not enough funds!') if @account < movie_price
      @account -= movie_price
      Netflix.add_money(movie_price)
      super movie
    end
  end
end