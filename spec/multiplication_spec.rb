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

  describe "#==" do
    it 'asserts equality when arguments are the same' do
      mtp_1 = mtp(1,2,'x')
      mtp_2 = mtp(1,2,'x')
      expect(mtp_1).to eq mtp_2
    end

    it 'asserts equality when exp arguments are the same' do
      mtp_1 = mtp(1,add(1,'y'),'x')
      mtp_2 = mtp(1,add(1,'y'),'x')
      expect(mtp_1).to eq mtp_2
    end

    it 'asserts inequality when exp arguments are the same' do
      mtp_1 = mtp(1,2,3)
      mtp_2 = mtp(1,2,)
      expect(mtp_1).not_to eq mtp_2
    end
  end

  describe '#evaluate' do
    it 'evaluates to a product of the arguments' do
      multiplication = mtp(1,-2,3)
      expect(multiplication.evaluate).to eq -6
    end

    it 'evaluates x * x to x^2' do
      multiplication = mtp('x','x')
      expect(multiplication.evaluate).to eq pow('x',2)
    end
  end

  describe '#simplify' do
    it 'simplifies 2x * 3x' do
      exp = mtp(mtp(2,'x'),mtp(3,'x'))
      # expect(exp.simplify).to eq mtp(6,mtp('x','x'))
      expect(exp.simplify).to eq mtp(6,'x','x')
    end
  end

  describe '#convert_to_power' do
    it 'converts string arguments to power of one' do
      exp = mtp(2,'x','y')
      exp.convert_to_power
      expect(exp.args).to eq [2,pow('x',1),pow('y',1)]
    end
  end

end
