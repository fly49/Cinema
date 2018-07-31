require_relative 'lib/netflix'
require_relative 'lib/theatre'
require 'money'

netflix = Netflix.new('movies.txt')
theatre = Theatre.new('movies.txt')

# puts Netflix.cash
# netflix.pay(25)
# puts Netflix.cash
# netflix.show(genre: 'Drama', period: :classic, country: 'France')
# puts Netflix.cash

puts theatre.cash
puts theatre.buy_ticket('The Kid')
puts theatre.cash

# theatre.take('banka')
# puts theatre.cash

money = Money.new(1000, 'USD')
puts money.class
