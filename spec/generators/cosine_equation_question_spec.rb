describe CosineEquationQuestion do
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
      expect(exp.evaluate_numerals).to eq 50
    end

    it 'a = 2, b = -20 and rs = frac(1/sqrt(2)) eval x to ' do
      exp = described_class.new
      allow(exp).to receive(:a).and_return({ value: 2, sign: '+@' })
      allow(exp).to receive(:b).and_return(-20)
      allow(exp).to receive(:rs).and_return({ value: frac(1, sqrt(2)), sign: '-@' })
      expect(exp.evaluate_numerals).to eq 77.5
    end
  end

  context 'generates sine equation in the form of sin(ax+b) = c' do
    it "equation srand 100" do
      srand(102)
      exp = described_class.new
      gen_eqn = exp.generate_equation
      expect(gen_eqn).to eq cos_eqn(add(div('x', 2), 100), frac(1, sqrt(2)))
    end

    it "equation srand 103" do
      srand(104)
      exp = described_class.new
      gen_eqn = exp.generate_equation
      expect(gen_eqn).to eq cos_eqn(add(mtp(3, 'x'), 42), frac(1, sqrt(2), sign: :-))
    end
  end

  context '#generate_question' do
    it 'returns instance of CosineEqQuestion' do
      exp = described_class.generate_question
      expect(exp).to be_a(CosineEquationQuestion)
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
      srand(105)
      exp = described_class.generate_question
      expect(exp.question_latex).to eq '\cos \left(53-\displaystyle\frac{x}{3}\right)&=\frac{1}{2}'
    end
  end

  context '#solution_latex' do
    it "returns latex for question solution" do
      srand(104)
      exp = described_class.generate_question
      # puts exp.solution_latex
      expect(exp.solution_latex).to eq "\\begin{align*}\n &&  && \\cos \\left(3x+42\\right)&=-\\frac{1}{\\sqrt{2}} &&  && \\\\[10pt]\n && &(1)&\\cos \\left(3x+42\\right)&=-\\frac{1}{\\sqrt{2}} && \\\\\n &&  && 3x+42&=\\arccos -\\frac{1}{\\sqrt{2}} &&  && \\\\\n &&  && 3x+42&=135 &&  && \\\\\n &&  && 3x&=135-42 &&  && \\\\\n &&  && 3x&=93 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{93}{3} &&  && \\\\\n &&  && x&=31\\pm 120n &&  && \\\\[10pt]\n && &(2)&\\cos \\left(-\\left(3x+42\\right)\\right)&=-\\frac{1}{\\sqrt{2}} && \\\\\n &&  && -\\left(3x+42\\right)&=\\arccos -\\frac{1}{\\sqrt{2}} &&  && \\\\\n &&  && -\\left(3x+42\\right)&=135 &&  && \\\\\n &&  && 3x+42&=\\displaystyle\\frac{135}{-1} &&  && \\\\\n &&  && 3x+42&=-135 &&  && \\\\\n &&  && 3x&=-135-42 &&  && \\\\\n &&  && 3x&=-177 &&  && \\\\\n &&  && x&=\\displaystyle\\frac{-177}{3} &&  && \\\\\n &&  && x&=-59\\pm 120n &&  && \n\\end{align*}\n$x= 31,151,271,61,181,301$"
    end
  end
end
