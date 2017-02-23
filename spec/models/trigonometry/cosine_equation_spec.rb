describe CosineEquation do
  describe '#solve' do
    it 'solves cos(x) = 0.5 for values between 0 and 360 degrees' do
      eqn = cos_eqn('x',0.5)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(cos('x'),0.5),
        eqn('x',arccos(0.5)),
        eqn('x',60)
      ]
      expect(result[:set_2][:steps]).to eq [
        eqn(cos(mtp(-1,'x')),0.5),
        eqn(mtp(-1,'x'),arccos(0.5)),
        eqn(mtp(-1,'x'),60),
        eqn('x',div(60, -1)),
        eqn('x',-60)
      ]
      expect(result[:set_1][:period]).to eq 360
      expect(result[:set_2][:period]).to eq 360
      expect(result[:solutions]).to eq [60, 300]
    end

    it 'solves cos(2x-10) = 0.5 for values between 0 and 360 degrees' do
      eqn = cos_eqn(sbt(mtp(2,'x'),10),0.5)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(cos(sbt(mtp(2,'x'),10)),0.5),
        eqn(sbt(mtp(2,'x'),10),arccos(0.5)),
        eqn(sbt(mtp(2,'x'),10),60),
        eqn(mtp(2,'x'),add(60,10)),
        eqn(mtp(2,'x'),70),
        eqn('x',div(70,2)),
        eqn('x',35)
      ]
      expect(result[:set_2][:steps]).to eq [
        eqn(cos(mtp(-1,sbt(mtp(2,'x'),10))),0.5),
        eqn(mtp(-1,sbt(mtp(2,'x'),10)),arccos(0.5)),
        eqn(mtp(-1,sbt(mtp(2,'x'),10)),60),
        eqn(sbt(mtp(2,'x'),10),div(60, -1)),
        eqn(sbt(mtp(2,'x'),10),-60),
        eqn(mtp(2,'x'),add(-60,10)),
        eqn(mtp(2,'x'),-50),
        eqn('x',div(-50,2)),
        eqn('x',-25)
      ]

      expect(result[:set_1][:period]).to eq 180
      expect(result[:set_2][:period]).to eq 180
      expect(result[:solutions]).to eq [35, 215, 155, 335]
    end

    it 'solves sin(2x-10) = -0.5 for values between 0 and 360 degrees' do
      eqn = cos_eqn(sbt(mtp(2,'x'),10),-0.5)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(cos(sbt(mtp(2,'x'),10)),-0.5),
        eqn(sbt(mtp(2,'x'),10),arccos(-0.5)),
        eqn(sbt(mtp(2,'x'),10),120),
        eqn(mtp(2,'x'),add(120,10)),
        eqn(mtp(2,'x'),130),
        eqn('x',div(130,2)),
        eqn('x',65)
      ]
      expect(result[:set_2][:steps]).to eq [
        eqn(cos(mtp(-1,sbt(mtp(2,'x'),10))),-0.5),
        eqn(mtp(-1,sbt(mtp(2,'x'),10)),arccos(-0.5)),
        eqn(mtp(-1,sbt(mtp(2,'x'),10)),120),
        eqn(sbt(mtp(2,'x'),10),div(120, -1)),
        eqn(sbt(mtp(2,'x'),10),-120),
        eqn(mtp(2,'x'),add(-120,10)),
        eqn(mtp(2,'x'),-110),
        eqn('x',div(-110,2)),
        eqn('x',-55)
      ]

      expect(result[:set_1][:period]).to eq 180
      expect(result[:set_2][:period]).to eq 180
      expect(result[:solutions]).to eq [65, 245, 125, 305]
    end

    it 'solves sin(0.5x) = 0.5 for values between 0 and 360 degrees' do
      eqn = cos_eqn(mtp(0.5,'x'),0.5)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(cos(mtp(0.5,'x')),0.5),
        eqn(mtp(0.5,'x'),arccos(0.5)),
        eqn(mtp(0.5,'x'),60),
        eqn('x',div(60,0.5)),
        eqn('x',120)
      ]
      expect(result[:set_2][:steps]).to eq [
        eqn(cos(mtp(-1, mtp(0.5,'x'))),0.5),
        eqn(mtp(-1, mtp(0.5,'x')),arccos(0.5)),
        eqn(mtp(-1, mtp(0.5,'x')),60),
        eqn(mtp(0.5,'x'),div(60, -1)),
        eqn(mtp(0.5,'x'),-60),
        eqn('x',div(-60,0.5)),
        eqn('x',-120)
      ]

      expect(result[:set_1][:period]).to eq 720
      expect(result[:set_2][:period]).to eq 720
      expect(result[:solutions]).to eq [120]
    end
  end
end
