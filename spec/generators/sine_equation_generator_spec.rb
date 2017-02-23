describe SineEquationGenerator do
  context '#select_a' do
    it "selects a value and sign srand 100" do
      srand(100)
      exp = described_class.new
      exp.select_a
      response = { value: frac(1, 3), sign: '-@' }
      expect(exp.a).to eq response
    end

    it "selects a value and sign srand 103" do
      srand(103)
      exp = described_class.new
      exp.select_a
      response = { value: 6, sign: '+@' }
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
      expect(exp.evaluate_numerals).to eq 9.607300918301275
    end
  end

  context '#select_variables' do
    
  end

  context 'generates sine equation in the form of sin(ax+b) = c' do
    it "equation srand 100" do
      srand(100)

    end
  end
end
