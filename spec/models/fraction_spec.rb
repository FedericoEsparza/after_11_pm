describe Factory do
  context '#initialize' do
    it 'sign is +' do
      exp = frac(12, 32)
      expect(exp.sign).to eq '+@'
    end

    it 'sign is -' do
      exp = frac(12, 32, sign: :-)
      expect(exp.sign).to eq '-@'
    end
  end

  context '#evaluate_numeral' do
    it 'evaluate 5/2 to 2.5' do
      exp = frac(5, 2)
      expect(exp.evaluate_numeral).to eq 2.5
    end

    it 'evaluate 2/3 to 0.66667' do
      exp = frac(2, 3)
      expect(exp.evaluate_numeral).to eq 0.6666666666666666
    end

    xit 'evaluate sqrt(3)/3 to 0.57735' do
      exp = frac(sqrt(3), 3)
      expect(exp.evaluate_numeral).to eq 0.57735
    end

    it 'evaluate -2/3 to -0.66667' do
      exp = frac(2, 3, sign: :-)
      expect(exp.evaluate_numeral).to eq -0.6666666666666666
    end

    it 'evaluate -(-2/3) to 0.66667' do
      exp = frac(-2, 3, sign: :-)
      expect(exp.evaluate_numeral).to eq 0.6666666666666666
    end
  end

  context '#<' do
    it 'compare 2/3 and 1/3 to false' do
      exp_1, exp_2 = frac(2, 3), frac(1, 3)
      expect(exp_1 < exp_2).to be false
    end

    it 'compare 2/3 and 2/2 to true' do
      exp_1, exp_2 = frac(2, 3), frac(2, 2)
      expect(exp_1 < exp_2).to be true
    end

    it 'compare 1/2 and 1/2 to false' do
      exp_1, exp_2 = frac(1, 2), frac(1, 2)
      expect(exp_1 < exp_2).to be false
    end

    it 'compare -3/6 and 3/6 to false' do
      exp_1, exp_2 = frac(3, 6, sign: :-), frac(3, 6)
      expect(exp_1 < exp_2).to be true
    end

    it 'compare -3/6 and -3/6 to true' do
      exp_1, exp_2 = frac(3, 6, sign: :-), frac(3, 6, sign: :-)
      expect(exp_1 < exp_2).to be false
    end

    it 'compares -1/2 and 1 to true' do
      exp_1, exp_2 = frac(1, 2, sign: :-), 1
      expect(exp_1 < exp_2).to be true
    end

    it 'compares -3/2 and -2.1 to false' do
      exp_1, exp_2 = frac(3, 2, sign: :-), -2.1
      expect(exp_1 < exp_2).to be false
    end
  end

  context '#>' do
    it 'compare 2/3 and 1/3 to false' do
      exp_1, exp_2 = frac(2, 3), frac(1, 3)
      expect(exp_1 > exp_2).to be true
    end

    it 'compare 2/3 and 2/2 to true' do
      exp_1, exp_2 = frac(2, 3), frac(2, 2)
      expect(exp_1 > exp_2).to be false
    end

    it 'compare 1/2 and 1/2 to false' do
      exp_1, exp_2 = frac(1, 2), frac(1, 2)
      expect(exp_1 > exp_2).to be false
    end

    it 'compare -3/6 and 3/6 to false' do
      exp_1, exp_2 = frac(3, 6, sign: :-), frac(3, 6)
      expect(exp_1 > exp_2).to be false
    end

    it 'compare -3/6 and -3/6 to true' do
      exp_1, exp_2 = frac(3, 6, sign: :-), frac(3, 6, sign: :-)
      expect(exp_1 > exp_2).to be false
    end

    it 'compares -1/2 and 1 to false' do
      exp_1, exp_2 = frac(1, 2, sign: :-), 1
      expect(exp_1 > exp_2).to be false
    end

    it 'compares -3/2 and -2.1 to true' do
      exp_1, exp_2 = frac(3, 2, sign: :-), -2.1
      expect(exp_1 > exp_2).to be true
    end
  end

  describe 'prime_factorisation' do
    it 'simplifies 24/30' do
      exp = frac(24, 30)
      result = exp.simplify
      expect(result).to eq frac(4,5)
    end

    it 'simplifies 250/1000' do
      exp = frac(250,1000)
      result = exp.simplify
      expect(result).to eq frac(1,4)
    end

    it 'simplify 125/81' do
      exp = frac(125,81)
      result = exp.simplify
      expect(result).to eq frac(125,81)
    end

    it 'simplify -50/35' do
      exp = frac(50,35,sign: :-)
      result = exp.simplify
      expect(result).to eq frac(10,7,sign: :-)
    end

    it 'simplify 250/5' do
      exp = frac(250,5)
      result = exp.simplify
      expect(result).to eq 50
    end

    it 'simplify -50/25' do
      exp = frac(50,25,sign: :-)
      result = exp.simplify
      expect(result).to eq -2
    end

    it 'simplify 1/3' do
      exp = frac(1,3)
      result = exp.simplify
      expect(result).to eq frac(1,3)
    end

    it 'simplify 3/1' do
      exp = frac(3,1)
      result = exp.simplify
      expect(result).to eq 3
    end

    it 'simplify frac(-9/3)' do
      exp = frac(-9,3)
      result = exp.simplify
      expect(result).to eq -3
    end
  end
end
