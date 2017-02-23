describe SquareRoot do
  context '#initialize' do
    it 'sign is +' do
      exp = sqrt(12)
      expect(exp.sign).to eq '+@'
    end

    it 'sign is -' do
      exp = sqrt(12, sign: :-)
      expect(exp.sign).to eq '-@'
    end
  end

  context '#value=' do
    it 'changes value to 20' do
      exp = sqrt(12)
      exp.value = 20
      expect(exp.value).to eq 20
    end
  end

  context '#evaluate_numeral' do
    it 'evaluates sqrt(4) to 2' do
      exp = sqrt(4)
      expect(exp.evaluate_numeral).to eq 2
    end

    it 'evaluates -sqrt(9) to -3' do
      exp = sqrt(9, sign: :-)
      expect(exp.evaluate_numeral).to eq -3
    end
  end
end
