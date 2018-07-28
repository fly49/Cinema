require_relative 'lib/netflix'
require_relative 'lib/theatre'

netflix = Netflix.new('movies.txt')
theatre = Theatre.new('movies.txt')

# netflix.show("Finding Nemo")
# netflix.pay(25)
# puts netflix.show(genre: 'Drama', period: :classic, country: 'France')
# puts netflix.account

# puts theatre.show(:special)
puts theatre.when?('The Kid')