require_relative 'lib/movie_collection'

collection = MovieCollection.new('movies.txt')

puts 'has_genre? test:'
puts collection.all.first.has_genre?('Drama')

puts 'Sorting test:'
puts collection.sort_by(:date)
puts collection.sort_by(:duration)

puts 'Stats test:'
puts collection.stats(:director)
puts collection.stats(:month)
puts collection.stats(:year)
puts collection.stats(:country)
puts collection.stats(:genre)
puts collection.stats(:cast)

puts 'Filtering test:'
puts collection.filter(year: 2001..2009)
puts collection.filter(genre: 'Comedy')
puts collection.filter(cast: /Schwarz(.*)/)
puts 'combined filtering'
puts collection.filter(genre: 'Animation', year: 2000..2005)

puts 'Exception test:'
begin
  puts collection.all.first.has_genre?('Action')
  puts collection.all.first.has_genre?('Crime')
  puts collection.all.first.has_genre?('Ccomdy')
rescue StandardError => error
  puts "Sorry! #{error.message}"
end

puts collection.find('Finding Nem')
# TABLE = %w[link title year country date genre duration rating director cast].freeze
# p CSV.read("movies.txt", col_sep: '|', headers: TABLE).map{ |a| a.to_h }