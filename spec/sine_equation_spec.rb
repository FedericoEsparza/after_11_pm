require './models/sine_equation'
require './models/factory'

include Factory

describe SineEquation do
  describe '#initialize' do
    it 'initialize with angle in degrees' do
      exp = sin_eqn('x',30,0,360)
      expect(exp.ls).to eq 'x'
      expect(exp.rs).to eq 30
      expect(exp.ans_min).to eq 0
      expect(exp.ans_max).to eq 360
    end

    it 'can init with array' do
      exp = sin([60])
      expect(exp.angle).to eq 60
    end
  end

end
