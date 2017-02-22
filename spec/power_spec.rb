require './models/power'
require './models/multiplication'

describe Power do
  describe '#initialize/new' do
    it 'initialize with an array of two values take power' do
      power = pow('x',2)
      expect(power.class).to eq described_class
      expect(power.base).to eq 'x'
      expect(power.index).to eq 2
      expect(power.args).to eq ['x',2]
    end
  end

  describe '#base=' do
    it 'sets args[0] value' do
      power = pow('x',2)
      power.base = 'y'
      expect(power.base).to eq 'y'
      expect(power.args[0]).to eq 'y'
    end
  end

  describe '#index=' do
    it 'sets args[0] value' do
      power = pow('x',2)
      power.index = 3
      expect(power.index).to eq 3
      expect(power.args[1]).to eq 3
    end
  end

  describe "#==" do
    it 'asserts equality when arguments are the same' do
      pow_1 = pow('x',2)
      pow_2 = pow('x',2)
      expect(pow_1).to eq pow_2
    end

    it 'asserts equality with tricky arguments' do
      pow_1 = pow(pow('x','y'),3)
      pow_2 = pow(pow('x','y'),3)
      expect(pow_1).to eq pow_2
    end

  end

  describe '#>' do
    it 'asserts x^3 > x^2' do
      pow_1 = pow('x',3)
      pow_2 = pow('x',2)
      result = pow_1 > pow_2
      expect(result).to eq true
    end

    it 'asserts y^2 > x^3' do
      pow_1 = pow('y',3)
      pow_2 = pow('x',2)
      result = pow_1 > pow_2
      expect(result).to eq true
    end

    it 'asserts x^2 > xy' do
      pow_1 = pow('x',2)
      pow_2 = mtp('x','y')
      result = pow_1 > pow_2
      expect(result).to eq true
    end
  end

  describe '#evaluate' do
    it 'evaluates to a product of the arguments' do
      power = pow(-2,3)
      expect(power.evaluate).to eq -8
    end
  end
end
