require 'theatre'
require 'rspec/its'

describe Theatre do
  let(:theatre) { Theatre.new('movies.txt') }
  let(:ancient_movie) { 'The Kid' }
  let(:adventure_movie) {'Lawrence of Arabia'}
  let(:comedy) {'Up'}
  let(:drama) {'Amadeus'}
  let(:horror) {'The Shining'}
  
  describe '.when?' do
    context 'morning' do
      it { expect( theatre.when?(ancient_movie) ).to eq :morning }
    end
    context 'noon' do
      it { expect( theatre.when?(adventure_movie) ).to eq :noon }
      it { expect( theatre.when?(comedy) ).to eq :noon }
    end
    context 'evening' do
      it { expect( theatre.when?(drama) ).to eq :evening }
      it { expect( theatre.when?(horror) ).to eq :evening }
    end
  end
  
  describe '.show' do
    context 'in the morning' do
      it { expect( theatre.show(:morning) ).to have_attributes( :period => :ancient ) }
    end
    context 'in the noon' do
      it { expect( theatre.show(:noon).genre ).to include('Adventure').or include('Comedy')  }
    end
    context 'in the evening' do
      it { expect( theatre.show(:evening).genre ).to include('Drama').or include('Horror')  }
    end
  end
end