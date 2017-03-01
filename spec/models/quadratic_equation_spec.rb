describe QuadraticEquation do

  describe '#simplify' do

    it 'simplifies 2x^2+10x+20' do
      exp = quad(2,10,20)
      result = exp.simplify
      expect(result).to eq quad(1,5,10)
    end
  end

  describe '#get_method' do
    it 'gets 12x^2+17x-7' do
      exp = quad(12,17,-7)
      result = exp.get_method
      expect(result["P"]).to eq [mtp(12,-7),-84]
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
      exp = quad(12,17,-7)
      result = exp.get_factors
      expect(result).to eq [-4,21]
    end
  end

  describe '#write_factors' do
    it 'writes factors for 12x^2+17x-7' do
      exp = quad(12,17,-7)
      result = exp.write_factors
      expect(result).to eq [[-4,21],[frac(-4,12),frac()]]
    end
  end

end
