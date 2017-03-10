describe FactoriseQuadraticEquation do
  describe '#is_quadratic?' do
    it 'returns true for 0=4x^2+3x-5' do
      equation = '0=4x^2+3x-5'.objectify
      expect(equation.is_quadratic?).to eq [pow('x',2),'x']
      expect(equation).to eq '0=4x^2+3x-5'.objectify
    end
  end



end
