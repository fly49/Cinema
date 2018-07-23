require 'movie_collection'
require 'rspec/its'

describe Movie do
  let(:data) do
    { link: 'http://imdb.com/title/tt0111161/?ref_=chttp_tt_1',
      title: 'The Shawshank Redemption',
      year: '1994',country: 'USA',
      date: '1994-10-14',
      genre: 'Crime,Drama',
      duration: '142 min',
      rating: '9.3',
      director: 'Frank Darabont',
      cast: 'Tim Robbins,Morgan Freeman,Bob Gunton' }
  end
  let(:dbl) { double(MovieCollection.new('movies.txt')) }
  subject { Movie.new(data, dbl) }

  describe 'it has been instantiated' do
    its(:link) { is_expected.to match(%r{ imdb.com\/title(.*) }) }
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