require_relative 'lib/netflix'
require_relative 'lib/theatre'

netflix = Netflix.new('movies.txt')
theatre = Theatre.new('movies.txt')

# netflix.show("Finding Nemo")
netflix.pay(25)
netflix.show(genre: 'Drama', period: :classic, country: 'France')
# puts netflix.account

theatre.show(:special)
#puts theatre.when?('The Kid')
table = %w[link title year country date genre duration rating director cast]
p 'http://imdb.com/title/tt0034583/?ref_=chttp_tt_32|Casablanca|1942|USA|1943-01-23|Drama,Romance,War|102 min|8.6|Michael Curtiz|Humphrey Bogart,Ingrid Bergman,Paul Henreid'.split('|')
.zip(table).to_h#.flatten.to_h