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
      expect(result[:set_1_period]).to eq 180
      expect(result[:set_2_period]).to eq 180
      expect(result[:solutions]).to eq [30,210,150,330]
    end

    it 'solves sin(2x-10) = 0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn(sbt(mtp(2,'x'),10),0.5)
      result = eqn.solve
      expect(result[:set_1]).to eq [
        eqn(sin(sbt(mtp(2,'x'),10)),0.5),
        eqn(sbt(mtp(2,'x'),10),arcsin(0.5)),
        eqn(sbt(mtp(2,'x'),10),30),
        eqn(mtp(2,'x'),add(30,10)),
        eqn(mtp(2,'x'),40),
        eqn('x',div(40,2)),
        eqn('x',20)
      ]
      expect(result[:set_2]).to eq [
        eqn(sin(sbt(180,sbt(mtp(2,'x'),10))),0.5),
        eqn(sbt(180,sbt(mtp(2,'x'),10)),arcsin(0.5)),
        eqn(sbt(180,sbt(mtp(2,'x'),10)),30),
        eqn(sbt(mtp(2,'x'),10),sbt(180,30)),
        eqn(sbt(mtp(2,'x'),10),150),
        eqn(mtp(2,'x'),add(150,10)),
        eqn(mtp(2,'x'),160),
        eqn('x',div(160,2)),
        eqn('x',80)
      ]
    end
  end
end
