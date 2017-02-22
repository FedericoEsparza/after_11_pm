require './models/fraction'
require './models/factory'

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

    it 'compare 1/2 and 1/2 to true' do
      exp_1, exp_2 = frac(1, 2), frac(1, 2)
      expect(exp_1 <= exp_2).to be true
    end

    it 'compare -3/6 and 3/6 to false' do
      exp_1, exp_2 = frac(3, 6, sign: :-), frac(3, 6)
      expect(exp_1 < exp_2).to be true
    end

    it 'compare -3/6 and -3/6 to true' do
      exp_1, exp_2 = frac(3, 6, sign: :-), frac(3, 6, sign: :-)
      expect(exp_1 <= exp_2).to be true
    end
  end
end
