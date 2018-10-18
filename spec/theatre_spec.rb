require 'spec_helper'
require 'cinema/theatre'

describe Cinema::Theatre do
  let(:theatre) do
    Cinema::Theatre.new('data/movies.txt') do
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
  end

  let(:theatre_without_block) { Cinema::Theatre.new('data/movies.txt') }
  let(:theatre_overlapped) do
    Cinema::Theatre.new('data/movies.txt') do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
      hall :green, title: 'Зелёный зал (deluxe)', places: 12

      period '16:00'..'20:00' do
        description 'Вечерний сеанс'
        filters genre: %w[Action Drama], year: 2007..Time.now.year
        price 20
        hall :red, :green
      end

      period '19:00'..'22:00' do
        description 'Вечерний сеанс для киноманов'
        filters year: 1900..1945, exclude_country: 'USA'
        price 30
        hall :green
      end
    end
  end

  describe 'it has been instantiated properly' do
    it 'should raise error if block is not given' do
      expect { theatre_without_block }.to raise_error(RuntimeError,'You need a block to build a theatre!')
    end
    it 'should raise error if time periods are overlapped' do
      expect { theatre_overlapped }.to raise_error(RuntimeError,'Time ranges overlap!')
    end
  end

  describe '.halls' do
    context 'should return all halls' do
      it { expect(theatre.halls.values).to all(be_a Cinema::Theatre::Hall) }
    end
  end

  describe '.periods' do
    context 'should return all periods' do
      it { expect(theatre.periods.values).to all(be_a Cinema::Theatre::Period) }
    end
  end

  describe '.show' do
    it 'should raise error if time is incorrect' do
      expect { theatre.show('04:20') }.to raise_error(RuntimeError,'Incorrect time!')
    end
    it 'should ask to specify the hall if needed' do
      expect { theatre.show('19:20') }.to raise_error(RuntimeError,'Please specfy the hall!')
    end
    context 'in the morning' do
      it { expect(theatre.show('09:20')).to have_attributes(genre: include('Comedy'), year: be_between(1900,1980)) }
      it 'should add 10$ to cashbox' do
        expect { theatre.show('09:20') }.to change { theatre.cash }.by Money.new(10 * 100, 'USD')
      end
    end
    context 'in the noon' do
      it { expect(theatre.show('11:20').title).to eq('The Terminator') }
      it 'should add 50$ to cashbox' do
        expect { theatre.show('11:20') }.to change { theatre.cash }.by Money.new(50 * 100, 'USD')
      end
    end
    context 'in the evening' do
      it { expect(theatre.show('16:20',:red).genre).to include('Drama').and include('Action') }
      it { expect(theatre.show('16:20',:red).year).to be_between(2007,Time.now.year) }
      it 'should add 20$ to cashbox' do
        expect { theatre.show('16:20',:red) }.to change { theatre.cash }.by Money.new(20 * 100, 'USD')
      end
    end
    context 'special session for cinemaholics' do
      it { expect(theatre.show('19:20',:green).year).to be_between(1900,1945) }
      it { expect(theatre.show('19:20',:green).country).not_to eq('USA') }
      it 'should add 30$ to cashbox' do
        expect { theatre.show('19:20',:green) }.to change { theatre.cash }.by Money.new(30 * 100, 'USD')
      end
    end
  end
end