require_relative 'movie_collection'
require_relative "fitness_selection"

class Netflix < MovieCollection
  include FitnessSelection
  attr_reader :account
  PRICE = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }
  
  def initialize(name)
    super
    @account = 0.0
  end
  
  def pay(amount)
    @account += amount
    #puts "#{amount}$ were successfully credited to your account. Current balance is #{@account}$."
  end
  
  def how_much?(name)
    PRICE[self.find(name).class.name.to_sym]
  end
  
  def proceed(movie)
    @account > self.how_much?(movie.title) ? @account -= self.how_much?(movie.title) : raise("Not enough funds!")
    return movie
  end
  
  def pick(arr)
    movie_name = f_selection( arr.each_with_object({}) { |mov, hash| hash[mov.title] = mov.rating } )
    find(movie_name)
  end
  
  def show(h)
    movie = pick( self.filter(h) )
    proceed(movie)
  end
end