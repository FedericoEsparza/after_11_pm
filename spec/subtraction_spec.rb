require './models/subtraction'
require './models/factory'

describe Subtraction do
  describe '#initialize' do
    it 'initialise with minuend and subend' do
      exp = sbt('x',3)
      expect(exp.minuend).to eq 'x'
      expect(exp.subend).to eq 3
    end

    it 'can init with array' do
      exp = sbt(['x',3])
      expect(exp.minuend).to eq 'x'
      expect(exp.subend).to eq 3
    end
  end

  describe 'setters for minuend and subend' do
    it 'setter for minuend' do
      exp = sbt('x',3)
      exp.minuend = 'y'
      expect(exp.minuend).to eq 'y'
    end

    it 'setter for subend' do
      exp = sbt('x',3)
      exp.subend = 4
      expect(exp.subend).to eq 4
    end
  end
end
