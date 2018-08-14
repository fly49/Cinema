require 'theatre'
require 'rspec/its'

describe Cinema::Hall do
  let(:theatre) do
    Cinema::Theatre.new('movies.txt') do
      hall :red, title: 'Красный зал', places: 100
    end
  end
  
  describe 'it has been instantiated properly' do
    subject { theatre.halls.values.first }
    it { is_expected.to be_a Cinema::Hall }
    its(:color) { is_expected.to eq(:red) }
    its(:title) { is_expected.to eq('Красный зал') }
    its(:places) { is_expected.to eq(100) }
  end
end