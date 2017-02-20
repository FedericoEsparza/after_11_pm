require './models/sine_equation'
require './models/factory'

include Factory

describe SineEquation do
  describe '#initialize' do
    it 'initialize with angle in degrees' do
      eqn = sin_eqn('x',0.5)
      expect(eqn.ls).to eq 'x'
      expect(eqn.rs).to eq 0.5
      default_options = {ans_min:0,ans_max:360}
      expect(eqn.options).to eq default_options
    end
  end

  describe '#solve' do
    it 'solves sin(x) = 0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn('x',0.5)
      result = eqn.solve
      expect(result[:set_1]).to eq [
        eqn(sin('x'),0.5),
        eqn('x',arcsin(0.5)),
        eqn('x',30)
      ]
      expect(result[:set_2]).to eq [
        eqn(sin(sbt(180,'x')),0.5),
        eqn(sbt(180,'x'),arcsin(0.5)),
        eqn(sbt(180,'x'),30),
        eqn('x',sbt(180,30)),
        eqn('x',150)
      ]
    end
  end
end
