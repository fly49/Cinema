require_relative 'MovieCollection'

collection = MovieCollection.new('movies.txt')

puts "has_genre? test:"
puts collection.all.first.has_genre?('Drama')

puts "Sorting test:"
puts collection.sort_by(:date)

puts "Filtering test:"
puts collection.filter(genre: 'Comedy')

puts "Stats test:"
puts collection.stats(:director)
puts collection.stats(:month)

puts "Exception test:"
begin
  puts collection.all.first.has_genre?('Tragedy')
  rescue StandardError => error
    puts "Error: You've missed! #{error.message}"
end

