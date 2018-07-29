require 'movie_collection'
require 'rspec/its'

describe Movie do
  let(:data) do
    { link: 'http://imdb.com/title/tt0111161/?ref_=chttp_tt_1',
      title: 'The Shawshank Redemption',
      year: '1994',
      country: 'USA',
      date: '1994-10-14',
      genre: 'Crime,Drama',
      duration: '142 min',
      rating: '9.3',
      director: 'Frank Darabont',
      cast: 'Tim Robbins,Morgan Freeman,Bob Gunton' }
  end
  let(:dbl) { double(MovieCollection.new('movies.txt')) }
  subject { Movie.new(data, dbl) }

  describe 'it has been instantiated properly' do
    its(:link) { is_expected.to match(%r{imdb.com\/title(.*)}) }
    its(:title, :country, :rating, :director, :month) { are_expected.to be_a(String) }
    its(:year, :duration) { are_expected.to be_a(Integer) }
    its(:genre, :cast) { are_expected.to be_a(Array) }
  end

  describe '.has_genre?' do
    before do
      allow(dbl).to receive_messages(genres: %w[Drama Action Crime])
    end
    it 'movie has this genre' do
      expect(subject.has_genre?('Drama')).to be true
    end
    it "movie hasn't this genre" do
      expect(subject.has_genre?('Action')).to be false
    end
    it 'incorrect genre' do
      expect { subject.has_genre?('Actn') }.to raise_error(RuntimeError,'Incorrect genre!')
    end
  end
end

describe "specified movies" do
  let(:table) { %w[link title year country date genre duration rating director cast] }
  let(:ancient_movie_data) do 
    data = 'http://imdb.com/title/tt0034583/?ref_=chttp_tt_32|Casablanca|1942|USA|1943-01-23|Drama,Romance,War|102 min|8.6|Michael Curtiz|Humphrey Bogart,Ingrid Bergman,Paul Henreid'
           .split('|')
    table.zip(data)
  end
  let(:classic_movie_data) do 
    data = 'http://imdb.com/title/tt0047478/?ref_=chttp_tt_20|Seven Samurai|1954|Japan|1956-11-19|Drama|207 min|8.7|Akira Kurosawa|Toshirô Mifune,Takashi Shimura,Keiko Tsushima'
           .split('|')
    table.zip(data)
  end
  let(:modern_movie_data) do 
    data = 'http://imdb.com/title/tt0114369/?ref_=chttp_tt_22|Se7en|1995|USA|1995-09-22|Drama,Mystery,Thriller|127 min|8.6|David Fincher|Morgan Freeman,Brad Pitt,Kevin Spacey'
           .split('|')
    table.zip(data)
  end
  let(:new_movie_data) do 
    data = 'http://imdb.com/title/tt2096673/?ref_=chttp_tt_53|Inside Out|2015|USA|2015-06-19|Animation,Adventure,Comedy|94 min|8.6|Pete Docter|Amy Poehler,Bill Hader,Lewis Black'
           .split('|')
    table.zip(data)
  end
  let(:dbl) { double(MovieCollection.new('movies.txt')) }
  let(:ancient_movie) { Movie.create(ancient_movie_data, dbl) }
  let(:classic_movie) { Movie.create(classic_movie_data, dbl) }
  let(:modern_movie) { Movie.create(modern_movie_data, dbl) }
  let(:new_movie) { Movie.create(new_movie_data, dbl) }
  
  it 'has been instantiated as specified movie' do
    expect(ancient_movie).to be_a AncientMovie
    expect(classic_movie).to be_a ClassicMovie
    expect(modern_movie).to be_a ModernMovie
    expect(new_movie).to be_a NewMovie
  end
  
  describe '.to_s' do
    before do
      allow(dbl).to receive_messages(stats: {'Akira Kurosawa' => 3 })
    end
    it 'prints as AncientMovie' do
      expect(ancient_movie.to_s).to match(/Old Movie/)
    end
    it 'prints as ClassicMovie' do
      expect(classic_movie.to_s).to match(/Classic Movie, director:/)
    end
    it 'prints as ModernMovie' do
      expect(modern_movie.to_s).to match(/Modern Movie: starring/)
    end
    it 'prints as NewMovie' do
      expect(new_movie.to_s).to match(/Brand-new Movie! Released/)
    end
  end
end