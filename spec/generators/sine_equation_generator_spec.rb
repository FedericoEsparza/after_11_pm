describe SineEquationQuestion do
  context '#select_a' do
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

  context '#evaluate_numerals' do
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
      expect(exp.evaluate_numerals).to eq -12.5
    end
  end

  context 'generates sine equation in the form of sin(ax+b) = c' do
    it "equation srand 100" do
      srand(102)
      exp = described_class.new
      gen_eqn = exp.generate_equation
      expect(gen_eqn).to eq sin_eqn(add(div('x', 2), 100), frac(1, 2, sign: :-))
    end

    it "equation srand 103" do
      srand(104)
      exp = described_class.new
      gen_eqn = exp.generate_equation
      expect(gen_eqn).to eq sin_eqn(add(mtp(3, 'x'), 42), frac(sqrt(3), 2))
    end

    it "equation srand 234" do
      srand(210)
      exp = described_class.new
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(35, mtp(5, 'x')), 0)
    end

    it "equation srand 234" do
      srand(210)
      exp = described_class.new(a_values: [2,3,4])
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(mtp(4, 'x'), 61), frac(1, sqrt(2), sign: :-))
    end

    it 'equation in the right format sin(2x - 20) = -frac(1, 2)' do
      exp = described_class.new
      allow(exp).to receive(:select_variables)
      allow(exp).to receive(:a).and_return({ value: 2, sign: '+@' })
      allow(exp).to receive(:b).and_return(-20)
      allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(mtp(2, 'x'), 20), frac(1, 2, sign: :-))
    end

    it 'equation in the right format sin(20 - 2x) = frac(1, 2)' do
      exp = described_class.new
      allow(exp).to receive(:select_variables)
      allow(exp).to receive(:a).and_return({ value: 2, sign: '-@' })
      allow(exp).to receive(:b).and_return(20)
      allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '+@' })
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(20, mtp(2, 'x')), frac(1, 2))
    end

    it 'equation in the right format sin(2x) = frac(1, 2)' do
      exp = described_class.new
      allow(exp).to receive(:select_variables)
      allow(exp).to receive(:a).and_return({ value: 2, sign: '+@' })
      allow(exp).to receive(:b).and_return(0)
      allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '+@' })
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(mtp(2, 'x'), frac(1, 2))
    end

    it 'equation in the right format sin(x - 20) = -frac(1, 2)' do
      exp = described_class.new
      allow(exp).to receive(:select_variables)
      allow(exp).to receive(:a).and_return({ value: 0, sign: '+@' })
      allow(exp).to receive(:b).and_return(-20)
      allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt('x', 20), frac(1, 2, sign: :-))
    end

    it 'equation in the right format sin(x/2 - 20) = -frac(1, 2)' do
      exp = described_class.new
      allow(exp).to receive(:select_variables)
      allow(exp).to receive(:a).and_return({ value: frac(1, 2), sign: '+@' })
      allow(exp).to receive(:b).and_return(-20)
      allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(div('x', 2), 20), frac(1, 2, sign: :-))
    end

    it 'equation in the right format sin(20 - x/3) = -frac(1, 2)' do
      exp = described_class.new
      allow(exp).to receive(:select_variables)
      allow(exp).to receive(:a).and_return({ value: frac(1, 3), sign: '-@' })
      allow(exp).to receive(:b).and_return(20)
      allow(exp).to receive(:rs).and_return({ value: frac(1, 2), sign: '-@' })
      gen_eqn = exp.generate_equation
      # puts gen_eqn.latex_solution
      expect(gen_eqn).to eq sin_eqn(sbt(20, div('x', 3)), frac(1, 2, sign: :-))
    end

    it 'specified A values to eq [5]' do
      exp = described_class.new(a_values: [5])
      gen_eqn = exp.generate_equation
      expect(gen_eqn).to eq sin_eqn(add(mtp(5, 'x'), 70), 0)
    end

    it 'specified B values to eq [4]' do
      exp = described_class.new(b_values: [5])
      gen_eqn = exp.generate_equation
      expect(gen_eqn).to eq sin_eqn(sbt(5, mtp(5, 'x')), 0)
    end
  end

  context '#generate_question' do
    it 'returns instance of SineEqQuestion' do
      exp = described_class.generate_question
      expect(exp).to be_a(SineEquationQuestion)
    end

    it 'when passed params it instanciates instance with those params' do
      exp = described_class.generate_question(limits: [180, 520], a_values:[5])
      expect(exp.limits).to eq [180, 520]
      expect(exp.a_values).to eq [5]
    end
  end

  context '#generate_solution' do
    it "calls #solve on question and returns solution hash" do
      exp = described_class.generate_question(a_values: [5])
      expect(exp.generate_solution).to be_a(Hash)
    end
  end

  context '#question_latex' do
    it "returns latex for question only" do
      exp = described_class.generate_question
      expect(exp.question_latex).to eq '\sin \left(11-x\right)&=0'
    end
  end

  context '#solution_latex' do
    it "returns latex for question solution" do
      exp = described_class.generate_question
      expect(exp.solution_latex).to eq "\\begin{align*}\n &&  && \\sin \\left(55-\\displaystyle\\frac{x}{3}\\right)&=0 &&  && \\\\[10pt]\n && &(1)&\\sin \\left(55-\\displaystyle\\frac{x}{3}\\right)&=0 && \\\\\n &&  && 55-\\displaystyle\\frac{x}{3}&=\\arcsin 0 &&  && \\\\\n &&  && 55-\\displaystyle\\frac{x}{3}&=0 &&  && \\\\\n &&  && \\displaystyle\\frac{x}{3}&=55-0 &&  && \\\\\n &&  && \\displaystyle\\frac{x}{3}&=55 &&  && \\\\\n &&  && x&=55\\times3 &&  && \\\\\n &&  && x&=165\\pm 1080n &&  && \\\\[10pt]\n && &(2)&\\sin \\left(180-\\left(55-\\displaystyle\\frac{x}{3}\\right)\\right)&=0 && \\\\\n &&  && 180-\\left(55-\\displaystyle\\frac{x}{3}\\right)&=\\arcsin 0 &&  && \\\\\n &&  && 180-\\left(55-\\displaystyle\\frac{x}{3}\\right)&=0 &&  && \\\\\n &&  && 55-\\displaystyle\\frac{x}{3}&=180-0 &&  && \\\\\n &&  && 55-\\displaystyle\\frac{x}{3}&=180 &&  && \\\\\n &&  && \\displaystyle\\frac{x}{3}&=55-180 &&  && \\\\\n &&  && \\displaystyle\\frac{x}{3}&=-125 &&  && \\\\\n &&  && x&=-125\\times3 &&  && \\\\\n &&  && x&=-375\\pm 1080n &&  && \n\\end{align*}\n$x= 165$"
    end
  end
end
