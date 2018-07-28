require 'theatre'
require 'rspec/its'

describe Theatre do
  let(:theatre) { Theatre.new('movies.txt') }

  describe '.when?' do
    it "should raise error if movie wasn't found" do
      expect { theatre.when?('abcd') }.to raise_error(RuntimeError,'Movie not found!')
    end
    context 'morning' do
      it { expect(theatre.when?('The Kid')).to eq :morning }
    end
    context 'noon' do
      it { expect(theatre.when?('Lawrence of Arabia')).to eq :noon }
      it { expect(theatre.when?('Up')).to eq :noon }
    end
    context 'evening' do
      it { expect(theatre.when?('Amadeus')).to eq :evening }
      it { expect(theatre.when?('The Shining')).to eq :evening }
    end
  end

  describe '.show' do
    it 'should raise error if time is incorrect' do
      expect { theatre.show(:afternoon) }.to raise_error(RuntimeError,'Incorrect time!')
    end
    context 'in the morning' do
      it { expect(theatre.show(:morning)).to have_attributes(period: :ancient) }
    end
    context 'in the noon' do
      it { expect(theatre.show(:noon).genre).to include('Adventure').or include('Comedy') }
    end
    context 'in the evening' do
      it { expect(theatre.show(:evening).genre).to include('Drama').or include('Horror') }
    end
    context 'special' do
      it { expect(theatre.show(:special).genre).to include('Drama').or include('Crime') }
      it { expect(theatre.show(:special).cast).to include('Al Pacino') }
    end
  end
end