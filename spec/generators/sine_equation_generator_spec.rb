describe SineEquationGenerator do
  xcontext '#select_a' do
    it "selects a value and sign srand 101" do
      srand(101)
      exp = described_class.new
      exp.select_a
      response = { value: frac(1, 3), sign: '-@' }
      expect(exp.a).to eq response
    end

    it "selects a value and sign srand 103" do
      srand(103)
      exp = described_class.new
      exp.select_a
      response = { value: 5, sign: '+@' }
      expect(exp.a).to eq response
    end
  end

  xcontext '#evaluate_numerals' do
    it 'a = 2, b = -10 and rs = 0 eval x to ' do
      srand(104)
      exp = described_class.new
      allow(exp).to receive(:a).and_return({ value: 2, sign: '+@' })
      allow(exp).to receive(:b).and_return(-10)
      allow(exp).to receive(:rs).and_return({ value: 0, sign: '-@' })
      expect(exp.evaluate_numerals).to eq 5
    end

    it 'a = 2, b = -20 and rs = frac(1/sqrt(2)) eval x to ' do
      exp = described_class.new
      allow(exp).to receive(:a).and_return({ value: 2, sign: '+@' })
      allow(exp).to receive(:b).and_return(-20)
      allow(exp).to receive(:rs).and_return({ value: frac(1, sqrt(2)), sign: '-@' })
      expect(exp.evaluate_numerals).to eq -13
    end
  end

  context '#select_variables' do
  end

  context 'generates sine equation in the form of sin(ax+b) = c' do
    # it "equation srand 100" do
    #   srand(102)
    #   exp = described_class.new
    #   gen_eqn = exp.generate_equation
    #   expect(gen_eqn).to eq sin_eqn(add(div('x', 2), 100), frac(1, 2, sign: :-))
    # end
#
    # it "equation srand 103" do
    #   srand(104)
    #   exp = described_class.new
    #   gen_eqn = exp.generate_equation
    #   expect(gen_eqn).to eq sin_eqn(add(mtp(3, 'x'), 42), frac(sqrt(3), 2))
    # end
    #
    xit "equation srand 234" do
      srand(210)
      exp = described_class.new
      gen_eqn = exp.generate_equation
      puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(mtp(6, 'x'), 32), frac(1, 2))
    end

    it "equation srand 234" do
      srand(210)
      exp = described_class.new(a_values: [2,3,4])
      gen_eqn = exp.generate_equation
      puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(mtp(6, 'x'), 32), frac(1, 2))
    end
    #
    # it 'equation in the right format sin(2x - 20) = -frac(1, 2)' do
    #   exp = described_class.new
    #   allow(exp).to receive(:select_variables)
    #   allow(exp).to receive(:a).and_return({ value: 2, sign: '+@' })
    #   allow(exp).to receive(:b).and_return(-20)
    #   allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
    #   gen_eqn = exp.generate_equation
    #   # puts gen_eqn.latex_solution
    #   expect(gen_eqn).to eq sin_eqn(sbt(mtp(2, 'x'), 20), frac(1, 2, sign: :-))
    # end
    #
    # it 'equation in the right format sin(20 - 2x) = frac(1, 2)' do
    #   exp = described_class.new
    #   allow(exp).to receive(:select_variables)
    #   allow(exp).to receive(:a).and_return({ value: 2, sign: '-@' })
    #   allow(exp).to receive(:b).and_return(20)
    #   allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '+@' })
    #   gen_eqn = exp.generate_equation
    #   # puts gen_eqn.latex_solution
    #   expect(gen_eqn).to eq sin_eqn(sbt(20, mtp(2, 'x')), frac(1, 2))
    # end
    #
    # it 'equation in the right format sin(2x) = frac(1, 2)' do
    #   exp = described_class.new
    #   allow(exp).to receive(:select_variables)
    #   allow(exp).to receive(:a).and_return({ value: 2, sign: '+@' })
    #   allow(exp).to receive(:b).and_return(0)
    #   allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '+@' })
    #   gen_eqn = exp.generate_equation
    #   # puts gen_eqn.latex_solution
    #   expect(gen_eqn).to eq sin_eqn(mtp(2, 'x'), frac(1, 2))
    # end
    #
    # it 'equation in the right format sin(x - 20) = -frac(1, 2)' do
    #   exp = described_class.new
    #   allow(exp).to receive(:select_variables)
    #   allow(exp).to receive(:a).and_return({ value: 0, sign: '+@' })
    #   allow(exp).to receive(:b).and_return(-20)
    #   allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
    #   gen_eqn = exp.generate_equation
    #   # puts gen_eqn.latex_solution
    #   expect(gen_eqn).to eq sin_eqn(sbt('x', 20), frac(1, 2, sign: :-))
    # end
    #
    # it 'equation in the right format sin(x/2 - 20) = -frac(1, 2)' do
    #   exp = described_class.new
    #   allow(exp).to receive(:select_variables)
    #   allow(exp).to receive(:a).and_return({ value: frac(1, 2), sign: '+@' })
    #   allow(exp).to receive(:b).and_return(-20)
    #   allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
    #   gen_eqn = exp.generate_equation
    #   # puts gen_eqn.latex_solution
    #   expect(gen_eqn).to eq sin_eqn(sbt(div('x', 2), 20), frac(1, 2, sign: :-))
    # end
    #
    # it 'equation in the right format sin(20 - x/3) = -frac(1, 2)' do
    #   exp = described_class.new
    #   allow(exp).to receive(:select_variables)
    #   allow(exp).to receive(:a).and_return({ value: frac(1, 3), sign: '-@' })
    #   allow(exp).to receive(:b).and_return(20)
    #   allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
    #   gen_eqn = exp.generate_equation
    #   # puts gen_eqn.latex_solution
    #   expect(gen_eqn).to eq sin_eqn(sbt(20, div('x', 3)), frac(1, 2, sign: :-))
    # end

  end
end
