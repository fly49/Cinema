require 'movie_collection'
require 'webmock/rspec'
require 'webmock'
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
  let(:tmdb_data) do
    { 'tt0111161' => ['The Shawshank Redemption',
                      'Побег из Шоушенка',
                      'http://image.tmdb.org/t/p/w154/sRBNv6399ZpCE4RrM8tRsDLSsaG.jpg'] }
  end
  let(:dbl) { double(Cinema::MovieCollection.new('movies.txt')) }
  let(:page) {"<div class=\"txt-block\"><h4 class=\"inline\">Budget:</h4>$25,000,000\n<span class=\"attribute\">(estimated)</span></div>"}
  let!(:stub) { WebMock.stub_request(:any, %r{imdb.com}).to_return(status: 200, body: page.to_yaml, headers: {}) }
  let(:get_budget) { Cinema::Movie.new(data, dbl).budget }

  describe '.get_budget' do
    it 'should connect to IMDB' do
      File.delete('movie_pages/tt0111161.html')
      WebMock.disable_net_connect!
      get_budget
      expect(stub).to have_been_requested.times(1)
    end
    it 'should save file and use it correctly' do
      expect(File).to exist('movie_pages/tt0111161.html')
      expect(get_budget).to eq('$25,000,000')
    end
  end
end