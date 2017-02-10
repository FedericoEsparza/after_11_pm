require './models/multiplication'
require './models/factory'

include Factory

describe Multiplication do
  describe '#initialize/new' do
    it 'initialize with an array of values to multiply' do
      multiplication = mtp(1,2,3)
      expect(multiplication.class).to eq described_class
      expect(multiplication.args).to eq [1,2,3]
    end
  end

  describe '#evaluate' do
    it 'evaluates to a product of the arguments' do
      multiplication = mtp(1,-2,3)
      expect(multiplication.evaluate).to eq -6
    end
  end
end
