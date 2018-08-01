require_relative 'lib/netflix'
require_relative 'lib/theatre'

netflix = Cinema::Netflix.new('movies.txt')
theatre = Cinema::Theatre.new('movies.txt')

# netflix.show("Finding Nemo")
netflix.pay(25)
netflix.show(genre: 'Drama', period: :classic, country: 'France')
# puts netflix.account

# theatre.show(:special)
# puts theatre.when?('The Kid')