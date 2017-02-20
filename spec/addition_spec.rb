require './models/expression'

describe Addition do
  describe '#initialize/new' do
    it 'initialize with an array of values to add' do
      addition = add(1,2,3)
      expect(addition.class).to eq described_class
      expect(addition.args).to eq [1,2,3]
    end
  end

  describe "#==" do
    it 'asserts equality when arguments are the same' do
      add_1 = add(1,2,'x')
      add_2 = add(1,2,'x')
      expect(add_1).to eq add_2
    end
  end

  describe '#evaluate' do
    it 'evaluates a sum of numbers' do
      addition = add(1,-2,3)
      expect(addition.evaluate).to eq 2
    end
  end

  describe '#simplify_add_m_forms' do
    addition = add(pow(var('x'),num(2)),mtp(var('x'),var('y')),mtp(var('y'),var('x')),pow(var('y'),num(2)))
    expect(addition.simplify_add_m_forms).to eq add(pow('x',2),mtp(2,'x','y'),pow('y',2))
  end

end
