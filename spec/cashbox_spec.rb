require 'cashbox'
require 'rspec/its'

describe Cashbox do
  let(:dummy_class) { Class.new { include Cashbox } }
  subject { dummy_class.new }

  describe '.cash' do
    it 'should return Money obj' do
      expect(subject.cash).to be_a Money
    end
  end

  describe '.add_money' do
    it 'should increase balance' do
      expect { subject.add_money 10 }.to change { subject.cash }.by Money.new(10 * 100, 'USD')
    end
  end

  describe '.take' do
    it 'should raise error if it is not a bank' do
      expect { subject.take 'mafia' }.to raise_error(RuntimeError,'It is illegal!')
    end
    before do
      subject.add_money 30
    end
    it 'zero the balance if it is a bank' do
      expect { subject.take 'bank' }.to change { subject.cash }.to Money.new(0, 'USD')
    end
  end
end