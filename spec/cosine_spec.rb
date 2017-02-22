require './models/cosine'
require './models/arc_cosine'
require './models/factory'

include Factory

describe Cosine do
  describe 'setters for angle' do
    it 'setter for angle' do
      exp = cos(60)
      exp.angle = 70
      expect(exp.angle).to eq 70
    end
  end

  describe '#==' do
    it 'copare object with same args true' do
      obj_1 = cos(60)
      obj_2 = cos(60)
      expect(obj_1 == obj_2).to be true
    end

    it 'compare object with diff args false' do
      obj_1 = cos(30)
      obj_2 = cos(60)
      expect(obj_1 == obj_2).to be false
    end
  end

  describe '#evaluate_numeral' do
    it 'evaluates cos(60) to 0.5 rad' do
      expect(cos(60).evaluate_numeral).to eq 0.5
    end

    it 'evaluates cos(90) to 0' do
      expect(cos(90).evaluate_numeral).to eq 0.0
    end
  end

  describe '#reverse_step' do
    it 'call inverse function' do
      exp = cos(60)
      response = { ls: 60, rs: arccos(60) }
      expect(exp.reverse_step(60)).to eq response
    end
  end
end
