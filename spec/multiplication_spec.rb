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
  end

  describe '#evaluate' do
    it 'evaluates to a product of the arguments' do
      multiplication = mtp(1,-2,3)
      expect(multiplication.evaluate).to eq -6
    end
  end
  #
  # describe '#simplify' do
  #   it 'simplifies 2x * 3x' do
  #     exp = mtp(mtp(2,'x'),mtp(3,'x'))
  #     expect(exp.simplify).to eq mtp(6,pow('x',2))
  #   end
  # end
end
