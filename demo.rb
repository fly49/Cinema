require_relative 'movie_collection'

collection = MovieCollection.new('movies.txt')

puts "has_genre? test:"
puts collection.all.first.has_genre?('Drama')

puts "Sorting test:"
puts collection.sort_by(:date)
puts collection.sort_by(:duration)

puts "Filtering test:"
puts collection.filter(genre: 'Comedy')
puts collection.filter(year: 2001..2009)
puts collection.filter(cast: /Schwarz(.*)/)

puts "Stats test:"
puts collection.stats(:director)
puts collection.stats(:month)
puts collection.stats(:year)
puts collection.stats(:country)
puts collection.stats(:genre)
puts collection.stats(:cast)

puts "Exception test:"
begin
  puts collection.all.first.has_genre?('Action')
  puts collection.all.first.has_genre?('Crime')
  puts collection.all.first.has_genre?('Ccomdy')
  rescue StandardError => error
    puts "Sorry! #{error.message}"

end

