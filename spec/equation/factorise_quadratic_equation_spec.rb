describe FactoriseQuadraticEquation do
  describe '#is_quadratic?' do
    it 'returns true for 0=4x^2+3x-5' do
      equation = '0=4x^2+3x-5'.objectify
      expect(equation.is_quadratic?).to eq true
      expect(equation).to eq '0=4x^2+3x-5'.objectify
    end

    it 'returns true for 0=3x-4x^2+3x-5' do
      equation = '0=3x-4x^2+3x-5'.objectify
      expect(equation.is_quadratic?).to eq true
      expect(equation).to eq '0=3x-4x^2+3x-5'.objectify
    end
  end




end
