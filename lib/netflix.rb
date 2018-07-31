require_relative 'movie_collection'

module Cinema
  class Netflix < MovieCollection
    extend Cashbox
    attr_reader :account
    PRICE = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }.freeze

    # def initialize(name)
    #  super (name)
    #  super()
    # end

    def pay(amount)
      Netflix.add_money(amount)
    end

    def how_much?(name)
      PRICE[find(name).class.name.to_sym]
    end

    def show(hash)
      movie = filter(hash).max_by { |m| m.rating * rand }
      Netflix.withdraw_money(how_much?(movie.title))
      super movie
    end
  end
end