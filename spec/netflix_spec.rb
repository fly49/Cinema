require 'netflix'
require 'rspec/its'

describe Cinema::Netflix do
  let(:netflix) { Cinema::Netflix.new('movies.txt') }

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
      context 'it should use a defined filter' do
        before do
          netflix.define_filter(:old) { |movie| movie.year < 1960 }
        end
        context 'returned movie should have pre-setted params' do
          subject { netflix.show(old: true) }
          its(:year) { is_expected.to be < 1960 }
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
    it 'should should store filters as blocks' do
      expect(netflix.filters[:custom_year]).to be_a Proc
    end
    it 'should define new filter based on old one' do
      expect(netflix.define_filter(:certain_custom_year, from: :custom_year, arg: 2014).arity).to eq 1
    end
  end
end