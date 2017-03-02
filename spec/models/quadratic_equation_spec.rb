describe QuadraticEquation do

  # describe '#simplify' do
  #
  #   it 'simplifies 2x^2+10x+20' do
  #     exp = quad(2,10,20)
  #     result = exp.simplify
  #     expect(result).to eq quad(1,5,10)
  #   end
  # end

  describe '#get_method' do
    it 'gets 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.get_method
      expect(result[:Product]).to eq [mtp(12,-7),-84]
    end
  end

  describe '#factorisation' do
    it 'gets factors of 12' do
      exp = 12
      result = exp.factorisation
      expect(result).to eq [[1,12],[2,6],[3,4],[4,3],[6,2],[12,1]]
    end
  end

  describe '#get_factors' do
    it 'calculates factors for 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.get_factors
      expect(result).to eq [-4,21]
    end
  end

  describe '#write_factors' do
    it 'writes factors for 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.write_factors
      expect(result).to eq [
        [-4,21],
        [frac(-4,12),frac(21,12)],
        [frac(1,3,sign: :-),frac(7,4)]
      ]

    end
  end

  describe '#write_factorisation_solution' do
    it 'writes solution for 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.write_factorisation_solution

      expect(result).to eq [
        '12x^2+17x+-7'.objectify,
        mtp(add('x',frac(1,3,sign: :-)),add('x',frac(7,4))),
        [frac(1,3),frac(7,4,sign: :-)]
      ]
    end

    it 'write solutin for 8x^2+10x-7' do
      exp = quad(8,10,-7,'x')
      result = exp.write_factorisation_solution

      expect(result).to eq [
        '8x^2+10x+-7'.objectify,
        mtp(add('x',frac(1,2,sign: :-)),add('x',frac(7,4))),
        [frac(1,2),frac(7,4,sign: :-)]
      ]
    end

  end

  describe '#latex_method' do
    exp = quad(8,10,-7,'x')
    result = exp.latex_method
    puts result
  end

  describe '#latex_factors' do
    exp = quad(8,10,-7,'x')
    result = exp.latex_factors
    puts result
  end


  describe '#latex' do
    it 'latexes $8y^2+10y-7$' do
      exp = quad(8,10,-7,'y')
      result = exp.latex
      puts result
    end
    it ' ' do end

    it 'latexes $x^2+5x+6$' do
      exp = quad(1,5,6,'x')
      result = exp.latex
      puts result
    end

    it ' ' do end

    it 'latexes $2x^2-9x+7$' do
      exp = quad(2,-9,7,'x')
      p exp
      result = exp.latex
      puts result
    end

    it ' ' do end

    it 'latexes $30x^2-19x-5$' do
      exp = quad(30,-19,-5,'x')
      result = exp.latex
      puts result
    end

    it ' ' do end

    it 'latexes $-6x^2+19x-8$' do
      exp = quad(-6,19,-8,'x')
      result = exp.latex
      puts result
    end

    it ' ' do end

    it 'latexes $-56x^2+31x-3$' do
      exp = quad(-56,31,-3,'x')
      result = exp.latex
      puts result
    end

    it ' ' do end

    it 'latexes $-16x^2-23x+18$' do
      exp = quad(-16,-23,18,'x')
      result = exp.latex
      puts result
    end

    it ' ' do end

    it 'latexes $3x^2 - 8x -3$' do
      exp = quad(3,-8,-3,'x')
      result = exp.latex
      puts result
    end

  end


end
