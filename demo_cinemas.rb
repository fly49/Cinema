require_relative 'lib/netflix'
require_relative 'lib/theatre'


# hash =
#    { link: 'http://imdb.com/title/tt0111161/?ref_=chttp_tt_1',
#      title: 'The Shawshank Redemption',
#      year: '1994',
#      country: 'USA',
#      date: '1994-10-14',
#      genre: 'Crime,Drama',
#      duration: '142 min',
#      rating: '9.3',
#      director: 'Frank Darabont',
#      cast: 'Tim Robbins,Morgan Freeman,Bob Gunton' }

collection = Cinema::MovieCollection.new('movies.txt')

# p movie = Cinema::Movie.create(hash, collection)
# p Cinema::Movie.ancestors

# netflix = Cinema::Netflix.new('movies.txt')
# theatre = Cinema::Theatre.new('movies.txt')

# puts netflix.by_genre.comedy
# puts '========'
# puts netflix.by_country.japan

# netflix.by_country.ussa

# netflix.show("Finding Nemo")
# netflix.pay(25)

# puts netflix.account
# netflix.define_filter(:new_custom_year, from: :custom_year, arg: 2014)
# netflix.show(new_custom_year: true)

# theatre.show(:special)
# puts theatre.when?('The Kid')

theatre =
  Cinema::Theatre.new('movies.txt') do
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12

    period '09:00'..'11:00' do
      description 'Утренний сеанс'
      filters genre: 'Comedy', year: 1900..1980
      price 10
      hall :red, :blue
    end

    period '11:00'..'16:00' do
      description 'Спецпоказ'
      title 'The Terminator'
      price 50
      hall :green
    end

    period '16:00'..'20:00' do
      description 'Вечерний сеанс'
      filters genre: %w[Action Drama], year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end

    period '19:00'..'22:00' do
      description 'Вечерний сеанс для киноманов'
      filters year: 1900..1945, exclude_country: 'USA'
      price 30
      hall :green
    end
  end
p theatre.halls
theatre.show('19:20',:green)



#theatre.show(:special)
#puts theatre.when?('The Kid')

#yaml = YAML.load_file("movies.txt")
#p yaml

Tmdb::Api.key("1f0a1ffab16aa952b101497e65a09e46")
netflix.all.first.link.match(%r{tt\d{5,7}})
movie = Tmdb::Find.movie(netflix.all.first.link.match(%r{tt\d{5,7}}), external_source: 'imdb_id', language: 'ru')
p movie

