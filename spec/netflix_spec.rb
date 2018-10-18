require 'spec_helper'
require 'cinema/netflix'
require 'rspec/its'
require 'rspec-html-matchers'

describe Cinema::Netflix do
  let(:netflix) { Cinema::Netflix.new('data/movies.txt') }

  describe '.pay' do
    it { expect { netflix.pay(5) }.to change { netflix.account }.by 5 }
  end

  describe '.how_much?' do
    it "should raise error if movie wasn't found" do
      expect { netflix.how_much?('abcd') }.to raise_error(RuntimeError,'Movie not found!')
    end
    context 'differen prices' do
      it { expect(netflix.how_much?('Citizen Kane')).to eq 1 }
      it { expect(netflix.how_much?('Lawrence of Arabia')).to eq 1.5 }
      it { expect(netflix.how_much?('Blade Runner')).to eq 3 }
      it { expect(netflix.how_much?('Up')).to eq 5 }
    end
  end

  describe '.show' do
    let(:movie_params) do
      { genre: 'Drama',
        period: :classic,
        country: 'France' }
    end

    context 'when not payed' do
      it 'should raise error when not enough funds' do
        expect { netflix.show(movie_params) }.to raise_error(RuntimeError,'Not enough funds!')
      end
    end

    context 'when payed' do
      before do
        netflix.pay(10)
      end
      it 'should decrease balance' do
        expect { netflix.show(movie_params) }.to change { netflix.account }.by(-1.5)
      end
      it 'should add money to cashbox' do
        expect { netflix.show(movie_params) }.to change { Cinema::Netflix.cash }.by Money.new(1.5 * 100, 'USD')
      end
      context 'returned movie should have pre-setted params' do
        subject { netflix.show(movie_params) }
        its(:genre) { is_expected.to include('Drama') }
        its(:period) { is_expected.to eq(:classic) }
        its(:country) { is_expected.to include('France') }
      end
      it 'should print a message' do
        time = Regexp.new(/([0-1][0-9]|[2][0-3]):[0-5][0-9]/)
        expect { netflix.show(movie_params) }.to output(/Now showing: «(.*?)» #{time} - #{time}/).to_stdout
      end
    end

    context 'filters usage' do
      before do
        netflix.pay(30)
      end
      context 'it should take a block' do
        let(:block) { proc { |movie| movie.genre.include?('Action') && movie.year == 2000 } }
        context 'returned movie should have pre-setted params' do
          subject { netflix.show(&block) }
          its(:genre) { is_expected.to include('Action') }
          its(:year) { is_expected.to eq 2000 }
        end
      end
      context 'it should use a defined filters' do
        before do
          netflix.define_filter(:before_60) { |movie| movie.year < 1960 }
          netflix.define_filter(:crimes_only) { |movie| movie.genre.include?('Crime') }
        end
        context 'returned movie should have pre-setted params' do
          subject { netflix.show(before_60: true, crimes_only: true) }
          its(:year) { is_expected.to be < 1960 }
          its(:genre) { is_expected.to include('Crime') }
        end
      end
      context 'it should use filter and hash combined' do
        before do
          netflix.define_filter(:not_usa) { |movie| !movie.country.include?('USA') }
        end
        context 'returned movie should have pre-setted params' do
          subject { netflix.show(not_usa: true, genre: 'Drama') }
          its(:country) { is_expected.not_to include 'USA' }
          its(:genre) { is_expected.to include('Drama') }
        end
      end
      context 'it should use a defined filter with extra options' do
        before do
          netflix.define_filter(:custom_year) { |movie, year| movie.year > year }
        end
        context 'returned movie should have pre-setted params' do
          subject { netflix.show(custom_year: 2010) }
          its(:year) { is_expected.to be > 2010 }
        end
      end
    end
  end

  describe '.define_filter' do
    before do
      netflix.define_filter(:custom_year) { |movie, year| movie.year > year }
    end
    it 'should store filters as blocks' do
      expect(netflix.filters[:custom_year]).to be_a Proc
    end
    it 'should define new filter based on old one' do
      expect(netflix.define_filter(:certain_custom_year, from: :custom_year, arg: 2014).arity).to eq 1
    end
    it 'should raise error if filter doesn\'t exist' do
      expect { netflix.define_filter(:certain_custom_year, from: :blabla, arg: 2014) }.to raise_error(RuntimeError,'Filter doesn\'t exist!')
    end
  end

  describe '.by_genre' do
    context 'it should return array of films with specified genre' do
      it { expect(netflix.by_genre.comedy).to all(have_attributes(genre: include('Comedy'))) }
    end
    it 'should raise error if entered genre is incorrect' do
      expect { netflix.by_genre.cmdy }.to raise_error(RuntimeError, 'Incorrect genre "cmdy".')
    end
  end

  describe '.by_county' do
    context 'it should return array of films with specified genre' do
      it { expect(netflix.by_country.japan).to all(have_attributes(country: include('Japan'))) }
    end
    it 'should raise error if entered genre is incorrect' do
      expect { netflix.by_country.jpan }.to raise_error(RuntimeError, 'No film from such country was found.')
    end
  end
  
  describe '.render_to' do
    include RSpecHtmlMatchers
    before { netflix.render_to('data/html_pages/page.html') }
    let(:rendered) { open('data/html_pages/page.html').read }
    it 'should contain columns with movie attributes' do
      expect(rendered).to have_tag('tr') do
        with_tag 'td', text: 'Title:'
        with_tag 'td', text: 'Year:'
        with_tag 'td', text: 'Country:'
        with_tag 'td', text: 'Date:'
        with_tag 'td', text: 'Genre:'
        with_tag 'td', text: 'Duration:'
        with_tag 'td', text: 'Director:'
        with_tag 'td', text: 'Budget:'
        with_tag 'td', text: 'Rating:'
        with_tag 'td', text: 'Cast:'
      end
    end
    it 'should support UTF-8' do
      expect(rendered).to have_tag('meta', with: { charset: 'UTF-8' })
    end
  end
end
