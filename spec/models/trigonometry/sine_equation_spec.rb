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
      expect(result[:set_1][:steps]).to eq [
        eqn(sin('x'),0.5),
        eqn('x',arcsin(0.5)),
        eqn('x',30)
      ]
      expect(result[:set_2][:steps]).to eq [
        eqn(sin(sbt(180,'x')),0.5),
        eqn(sbt(180,'x'),arcsin(0.5)),
        eqn(sbt(180,'x'),30),
        eqn('x',sbt(180,30)),
        eqn('x',150)
      ]
      expect(result[:set_1][:period]).to eq 360
      expect(result[:set_2][:period]).to eq 360
      expect(result[:solutions]).to eq [30,150]
    end

    it 'solves sin(2x-10) = 0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn(sbt(mtp(2,'x'),10),0.5)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(sin(sbt(mtp(2,'x'),10)),0.5),
        eqn(sbt(mtp(2,'x'),10),arcsin(0.5)),
        eqn(sbt(mtp(2,'x'),10),30),
        eqn(mtp(2,'x'),add(30,10)),
        eqn(mtp(2,'x'),40),
        eqn('x',div(40,2)),
        eqn('x',20)
      ]
      expect(result[:set_2][:steps]).to eq [
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

      expect(result[:set_1][:period]).to eq 180
      expect(result[:set_2][:period]).to eq 180
      expect(result[:solutions]).to eq [20, 200, 80, 260]
    end

    it 'solves sin(2x-10) = -0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn(sbt(mtp(2,'x'),10), -0.5)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(sin(sbt(mtp(2,'x'),10)),-0.5),
        eqn(sbt(mtp(2,'x'),10),arcsin(-0.5)),
        eqn(sbt(mtp(2,'x'),10),-30),
        eqn(mtp(2,'x'),add(-30,10)),
        eqn(mtp(2,'x'),-20),
        eqn('x',div(-20,2)),
        eqn('x',-10)
      ]
      expect(result[:set_2][:steps]).to eq [
        eqn(sin(sbt(180,sbt(mtp(2,'x'),10))),-0.5),
        eqn(sbt(180,sbt(mtp(2,'x'),10)),arcsin(-0.5)),
        eqn(sbt(180,sbt(mtp(2,'x'),10)),-30),
        eqn(sbt(mtp(2,'x'),10),sbt(180,-30)),
        eqn(sbt(mtp(2,'x'),10),210),
        eqn(mtp(2,'x'),add(210,10)),
        eqn(mtp(2,'x'),220),
        eqn('x',div(220,2)),
        eqn('x',110)
      ]

      expect(result[:set_1][:period]).to eq 180
      expect(result[:set_2][:period]).to eq 180
      expect(result[:solutions]).to eq [170, 350, 110, 290]
    end

    it 'solves sin(0.5x) = 0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn(mtp(0.5,'x'),0.5)
      result = eqn.solve
      expect(result[:set_1][:steps]).to eq [
        eqn(sin(mtp(0.5,'x')),0.5),
        eqn(mtp(0.5,'x'),arcsin(0.5)),
        eqn(mtp(0.5,'x'),30),
        eqn('x',div(30,0.5)),
        eqn('x',60)
      ]
      expect(result[:set_2][:steps]).to eq [
        eqn(sin(sbt(180,mtp(0.5,'x'))),0.5),
        eqn(sbt(180,mtp(0.5,'x')),arcsin(0.5)),
        eqn(sbt(180,mtp(0.5,'x')),30),
        eqn(mtp(0.5,'x'),sbt(180,30)),
        eqn(mtp(0.5,'x'),150),
        eqn('x',div(150,0.5)),
        eqn('x',300)
      ]

      expect(result[:set_1][:period]).to eq 720
      expect(result[:set_2][:period]).to eq 720
      expect(result[:solutions]).to eq [60, 300]
    end
  end

  describe '#evaluate_period' do
    it 'when sin(2x) = 0.5 for values between 0 and 360 degrees period 180' do
      eqn = sin_eqn(mtp(2, 'x'), 0.5)
      expect(eqn.evaluate_period).to eq 180
    end

    it 'when sin(4x) = 0.5 for values between 0 and 360 degrees period 90' do
      eqn = sin_eqn(mtp(4, 'x'), 0.5)
      expect(eqn.evaluate_period).to eq 90
    end

    it 'when sin(0.5x) = 0.5 for values between 0 and 360 degrees period 720' do
      eqn = sin_eqn(mtp(0.5, 'x'), 0.5)
      expect(eqn.evaluate_period).to eq 720
    end
  end

  describe '#equation_solutions' do
    it 'sin(2x) = 0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn(mtp(2, 'x'), 0.5)
      result = eqn.equation_solutions(set_1: eqn('x', 15),
                                      set_2: eqn('x', 75),
                                      period: 180 )
      response = [15, 195, 75, 255]
      expect(result).to eq response
    end

    it 'sin(0.5x) = 0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn(mtp(0.5, 'x'), 0.5)
      result = eqn.equation_solutions(set_1: eqn('x', 60),
                                      set_2: eqn('x', 300),
                                      period: 720 )
      response = [60, 300]
      expect(result).to eq response
    end

    it 'sin(3x) = 0.5 for values between 0 and 360 degrees' do
      eqn = sin_eqn(mtp(3, 'x'), 0.5)
      result = eqn.equation_solutions(set_1: eqn('x', 10),
                                      set_2: eqn('x', 50),
                                      period: 120 )
      response = [10, 130, 250, 50, 170, 290]
      expect(result).to eq response
    end

    it 'sin(0.5x) = 0.5 for values between 0 and 1440 degrees' do
      eqn = sin_eqn(mtp(0.5, 'x'), 0.5, { ans_min:0, ans_max: 1440 })
      result = eqn.equation_solutions(set_1: eqn('x', 60),
                                      set_2: eqn('x', 300),
                                      period: 720 )
      response = [60, 780, 300, 1020]
      expect(result).to eq response
    end

    it 'sin(2x) = 0.5 for values between 0 and 720 degrees' do
      eqn = sin_eqn(mtp(2, 'x'), 0.5, { ans_min:0, ans_max: 720 })
      result = eqn.equation_solutions(set_1: eqn('x', 15),
                                      set_2: eqn('x', 75),
                                      period: 180 )
      response = [15, 195, 375, 555, 75, 255, 435, 615]
      expect(result).to eq response
    end

    it 'sin(2x) = 0.5 for values between 0 and -360 degrees' do
      eqn = sin_eqn(mtp(2, 'x'), 0.5, { ans_min:-360, ans_max: 0 })
      result = eqn.equation_solutions(set_1: eqn('x', 15),
                                      set_2: eqn('x', 75),
                                      period: 180 )
      response = [-345, -165, -285, -105]
      expect(result).to eq response
    end

    it 'sin(2x) = 0.5 for values between -360 and 360 degrees' do
      eqn = sin_eqn(mtp(2, 'x'), 0.5, { ans_min:-360, ans_max: 360 })
      result = eqn.equation_solutions(set_1: eqn('x', 15),
                                      set_2: eqn('x', 75),
                                      period: 180 )
      response = [-345, -165, 15, 195, -285, -105, 75, 255]
      expect(result).to eq response
    end

    it 'sin(2x) = 0.5 for values between 180 and 360 degrees' do
      eqn = sin_eqn(mtp(2, 'x'), 0.5, { ans_min: 180, ans_max: 360 })
      result = eqn.equation_solutions(set_1: eqn('x', 15),
                                      set_2: eqn('x', 75),
                                      period: 180 )
      response = [195, 255]
      expect(result).to eq response
    end

  end
end
