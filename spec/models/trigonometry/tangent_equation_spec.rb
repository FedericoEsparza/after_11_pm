describe TangentEquation do
  describe '#solve' do
    it 'solves tan(x) = sqrt(3)/3 for values between 0 and 360 degrees' do
      eqn = tan_eqn('x', frac(sqrt(3), 3))
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(tan('x'),frac(sqrt(3), 3)),
        eqn('x',arctan(frac(sqrt(3), 3))),
        eqn('x', 30)
      ]

      expect(result[:set_1][:period]).to eq 180
      expect(result[:solutions]).to eq [30, 210]
    end

    it 'solves tan(2x-10) = sqrt(3)/3 for values between 0 and 360 degrees' do
      eqn = tan_eqn(sbt(mtp(2,'x'),10), Math.sqrt(3)/3)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(tan(sbt(mtp(2,'x'),10)), Math.sqrt(3)/3),
        eqn(sbt(mtp(2,'x'),10),arctan( Math.sqrt(3)/3)),
        eqn(sbt(mtp(2,'x'),10),30),
        eqn(mtp(2,'x'),add(30,10)),
        eqn(mtp(2,'x'),40),
        eqn('x',div(40,2)),
        eqn('x',20)
      ]

      expect(result[:set_1][:period]).to eq 90
      expect(result[:solutions]).to eq [20, 110, 200, 290]
    end

    it 'solves tan(0.5x-10) = sqrt(3)/3 for values between 0 and 360 degrees' do
      eqn = tan_eqn(sbt(mtp(0.5,'x'),10), Math.sqrt(3)/3)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(tan(sbt(mtp(0.5,'x'),10)), Math.sqrt(3)/3),
        eqn(sbt(mtp(0.5,'x'),10),arctan( Math.sqrt(3)/3)),
        eqn(sbt(mtp(0.5,'x'),10),30),
        eqn(mtp(0.5,'x'),add(30,10)),
        eqn(mtp(0.5,'x'),40),
        eqn('x',div(40,0.5)),
        eqn('x',80)
      ]

      expect(result[:set_1][:period]).to eq 360
      expect(result[:solutions]).to eq [80]
    end
  end
end
