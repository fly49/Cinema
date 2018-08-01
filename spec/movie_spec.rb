require 'movie_collection'
require 'rspec/its'

describe Cinema::Movie do
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
  let(:dbl) { double(Cinema::MovieCollection.new('movies.txt')) }
  subject { Cinema::Movie.new(data, dbl) }

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

describe 'specified movies' do
  let(:ancient_movie_data) do
    { link: 'http://imdb.com/title/tt0034583/?ref_=chttp_tt_32',
      title: 'Casablanca',
      year: '1942',
      country: 'USA',
      date: '1943-01-23',
      genre: 'Drama,Romance,War',
      duration: '102 min',
      rating: '8.6',
      director: 'Michael Curtiz',
      cast: 'Humphrey Bogart,Ingrid Bergman,Paul Henreid' }
  end
  let(:classic_movie_data) do
    { link: 'http://imdb.com/title/tt0047478/?ref_=chttp_tt_20',
      title: 'Seven Samurai',
      year: '1954',
      country: 'Japan',
      date: '1956-11-19',
      genre: 'Drama',
      duration: '207 min',
      rating: '8.7',
      director: 'Akira Kurosawa',
      cast: 'Toshirô Mifune,Takashi Shimura,Keiko Tsushima' }
  end
  let(:modern_movie_data) do
    { link: 'http://imdb.com/title/tt0114369/?ref_=chttp_tt_22',
      title: 'Se7en',
      year: '1995',
      country: 'USA',
      date: '1995-09-22',
      genre: 'Drama,Mystery,Thriller',
      duration: '127 min',
      rating: '8.6',
      director: 'David Fincher',
      cast: 'Morgan Freeman,Brad Pitt,Kevin Spacey' }
  end
  let(:new_movie_data) do
    { link: 'http://imdb.com/title/tt2096673/?ref_=chttp_tt_53',
      title: 'Inside Out',
      year: '2015',
      country: 'USA',
      date: '2015-06-19',
      genre: 'Animation,Adventure,Comedy',
      duration: '94 min',
      rating: '8.6',
      director: 'Pete Docter',
      cast: 'Amy Poehler,Bill Hader,Lewis Black' }
  end
  let(:dbl) { double(Cinema::MovieCollection.new('movies.txt')) }
  let(:ancient_movie) { Cinema::Movie.create(ancient_movie_data, dbl) }
  let(:classic_movie) { Cinema::Movie.create(classic_movie_data, dbl) }
  let(:modern_movie) { Cinema::Movie.create(modern_movie_data, dbl) }
  let(:new_movie) { Cinema::Movie.create(new_movie_data, dbl) }

  it 'has been instantiated as specified movie' do
    expect(ancient_movie).to be_a Cinema::AncientMovie
    expect(classic_movie).to be_a Cinema::ClassicMovie
    expect(modern_movie).to be_a Cinema::ModernMovie
    expect(new_movie).to be_a Cinema::NewMovie
  end

  describe '.to_s' do
    before do
      allow(dbl).to receive_messages(stats: { 'Akira Kurosawa' => 3 })
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