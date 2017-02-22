require './models/tangent'
require './models/arc_tangent'
require './models/factory'

include Factory

describe Tangent do
  describe 'setters for angle' do
    it 'setter for angle' do
      exp = tan(60)
      exp.angle = 70
      expect(exp.angle).to eq 70
    end
  end

  describe '#==' do
    it 'copare object with same args true' do
      obj_1 = tan(60)
      obj_2 = tan(60)
      expect(obj_1 == obj_2).to be true
    end

    it 'compare object with diff args false' do
      obj_1 = tan(30)
      obj_2 = tan(60)
      expect(obj_1 == obj_2).to be false
    end
  end

  describe '#evaluate_numeral' do
    it 'evaluates tan(45) to 1 rad' do
      expect(tan(45).evaluate_numeral).to eq 1
    end

    it 'evaluates tan(180) to 0' do
      expect(tan(180).evaluate_numeral).to eq 0.0
    end
  end

  describe '#reverse_step' do
    it 'call inverse function' do
      exp = tan(60)
      response = { ls: 60, rs: arctan(60) }
      expect(exp.reverse_step(60)).to eq response
    end
  end
end
