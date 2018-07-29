require_relative 'movie_collection'
require_relative 'fitness_selection'

class Netflix < MovieCollection
  attr_reader :account
  PRICE = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }.freeze

  def initialize(name)
    super
    @account = 0.0
  end

  def pay(amount)
    @account += amount
    # puts "#{amount}$ were successfully credited to your account. Current balance is #{@account}$."
  end

  def how_much?(name)
    PRICE[find(name).class.name.to_sym]
  end

  def show(hash)
    movie = filter(hash).max_by { |m| m.rating * rand }
    raise('Not enough funds!') if @account < how_much?(movie.title)
    @account -= how_much?(movie.title)
    super movie
  end
end