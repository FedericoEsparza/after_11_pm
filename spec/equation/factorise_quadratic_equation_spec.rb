describe FactoriseQuadraticEquation do
  describe '#test' do
    it 'matches outer brackets in \frac{frac{2}{y}}{x}' do
      equation = eqn('x',1)
      puts equation.test
    end
  end

end
