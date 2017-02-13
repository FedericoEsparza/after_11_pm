require './models/power'
require './models/factory'

include Factory

describe Power do
  describe '#initialize/new' do
    it 'initialize with an array of two values take power' do
      power = pow('x',2)
      expect(power.class).to eq described_class
      expect(power.base).to eq 'x'
      expect(power.index).to eq 2
    end
  end

  describe "#==" do
    it 'asserts equality when arguments are the same' do
      pow_1 = pow('x',2)
      pow_2 = pow('x',2)
      expect(pow_1).to eq pow_2
    end
  end

  describe '#evaluate' do
    it 'evaluates to a product of the arguments' do
      power = pow(-2,3)
      expect(power.evaluate).to eq -8
    end
  end
end
