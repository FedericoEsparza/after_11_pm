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
      expect(result).to eq [[-4,21],[frac(-4,12),frac(21,12)],[frac(-1,3),frac(7,4)]]

    end
  end

  describe '#write_factorisation_solution' do
    it 'writes solution for 12x^2+17x-7' do
      exp = quad(12,17,-7,'x')
      result = exp.write_factorisation_solution

      expect(result).to eq [
        '12x^2+17x+-7'.objectify,
        mtp(add('x',frac(-1,3)),add('x',frac(7,4))),
        [frac(1,3),frac(-7,4)]
      ]
    end

    it 'write solutin for 8x^2+10x-7' do
      exp = quad(8,10,-7,'x')
      result = exp.write_factorisation_solution

      expect(result).to eq [
        '8x^2+10x+-7'.objectify,
        mtp(add('x',frac(-1,2)),add('x',frac(7,4))),
        [frac(1,2),frac(-7,4)]
      ]
    end

  end

  # describe '#latex_method' do
  #   exp = quad(8,10,-7,'x')
  #   result = exp.latex_method
  #   puts result
  # end

  # describe '#latex_factors' do
  #   exp = quad(8,10,-7,'x')
  #   result = exp.latex_factors
  #   puts result
  # end


  describe '#latex' do
    it 'latexes' do
      exp = quad(8,10,-7,'y')
      result = exp.latex
      p result
    end
  end


end
