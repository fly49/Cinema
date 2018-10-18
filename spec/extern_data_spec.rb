require 'spec_helper'
require 'webmock/rspec'
require 'rspec/its'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'fileutils'
require 'cinema/movie_collection'
require 'cinema/movie_budget_getter'

describe 'Extern Data' do
  let!(:config_hash) { { "images": { "base_url": 'http://image.tmdb.org/t/p/',"secure_base_url": 'https://image.tmdb.org/t/p/',"backdrop_sizes": %w[w300 w780 w1280 original],"logo_sizes": %w[w45 w92 w154 w185 w300 w500 original],"poster_sizes": %w[w92 w154 w185 w342 w500 w780 original],"profile_sizes": %w[w45 w185 h632 original],"still_sizes": %w[w92 w185 w300 original] },"change_keys": %w[adult air_date also_known_as alternative_titles biography birthday budget cast certifications character_names created_by crew deathday episode episode_number episode_run_time freebase_id freebase_mid general genres guest_stars homepage images imdb_id languages name network origin_country original_name original_title overview parts place_of_birth plot_keywords production_code production_companies production_countries releases revenue runtime season season_number season_regular spoken_languages status tagline title translations tvdb_id tvrage_id type video videos] } }
  let!(:config_stub) { WebMock.stub_request(:any, %r{api.themoviedb.org/3/configuration}).to_return(status: 200, body: config_hash.to_json, headers: {}) }
  let!(:movie_hash) { { "movie_results": [{ "adult": false,"backdrop_path": '/j9XKiZrVeViAixVRzCta7h1VU9W.jpg',"genre_ids": [80,18],"id": 278,"original_language": 'en',"original_title": 'The Shawshank Redemption',"overview": 'Фильм удостоен шести номинаций на `Оскар`, в том числе и как лучший фильм года. Шоушенк - название тюрьмы. И если тебе нет еще 30-ти, а ты получаешь пожизненное, то приготовься к худшему: для тебя выхода из Шоушенка не будет! Актриса Рита Хэйворт - любимица всей Америки. Энди Дифрейну она тоже очень нравилась. Рита никогда не слышала о существовании Энди, однако жизнь Дифрейну, бывшему вице-президенту крупного банка, осужденному за убийство жены и ее любовника, Рита Хэйворт все-таки спасла.',"poster_path": '/sRBNv6399ZpCE4RrM8tRsDLSsaG.jpg',"release_date": '1994-09-23',"title": 'Побег из Шоушенка',"video": false,"vote_average": 8.6,"vote_count": 10_732,"popularity": 23.401 }],"person_results": [],"tv_results": [],"tv_episode_results": [],"tv_season_results": [] } }
  let!(:movie_stub) { WebMock.stub_request(:any, %r{api.themoviedb.org/3/find}).to_return(status: 200, body: movie_hash.to_json, headers: {}) }
  let!(:page) { "<div class=\"txt-block\"><h4 class=\"inline\">Budget:</h4>$25,000,000\n<span class=\"attribute\">(estimated)</span></div>" }
  let!(:imdb_stub) { WebMock.stub_request(:any, /imdb.com/).to_return(status: 200, body: page.to_yaml, headers: {}) }
  let(:tmdb_base) { YAML.parse(File.open('data/tmdb_base.yml')).transform }
  
  before(:all) do
    WebMock.disable_net_connect!
  end

  describe Cinema::TmdbDataGetter do
    describe '.fetch_all' do
      before(:all) do
        File.delete('data/tmdb_base.yml') if File.exist?('data/tmdb_base.yml')
      end
      
      it 'should connect with the tmdb API' do
        Cinema::MovieCollection.new('data/movies.txt')
        expect(config_stub).to have_been_requested.times(1)
        expect(movie_stub).to have_been_requested.times(250)
      end
    
      it 'should create proper YAML file' do
        expect(tmdb_base.keys.first).to eq('tt0111161')
        expect(tmdb_base.values[0]).to eq(['The Shawshank Redemption','Побег из Шоушенка','http://image.tmdb.org/t/p/w154/sRBNv6399ZpCE4RrM8tRsDLSsaG.jpg'])
      end
    end
  end
  
  describe Cinema::MovieBudgetGetter do
    describe '.get_all_budgets' do
      before(:all) do
        File.delete('data/budgets.yml') if File.exist?('data/budgets.yml')
      end
      
      it 'should connect to IMDB' do
        Cinema::MovieCollection.new('data/movies.txt')
        expect(imdb_stub).to have_been_requested.times(250)
      end
  
      describe 'it should create proper YAML file' do
        subject { YAML.parse(File.open('data/budgets.yml')).transform }
        it { expect(subject.keys.first).to eq('tt0111161') }
        it { expect(subject.values[0]).to eq('$25,000,000') }
      end
  
      after(:all) do
        File.delete('data/budgets.yml')
      end
    end
  end
end