require './models/sine'
require './models/factory'

include Factory

describe Sine do
  describe '#initialize' do
    it 'initialise with angle in degrees' do
      exp = sin(60)
      expect(exp.angle).to eq 60
    end

    it 'can init with array' do
      exp = sin([60])
      expect(exp.angle).to eq 60
    end
  end

  describe 'setters for angle' do
    it 'setter for angle' do
      exp = sin(60)
      exp.angle = 70
      expect(exp.angle).to eq 70
    end
  end
end
