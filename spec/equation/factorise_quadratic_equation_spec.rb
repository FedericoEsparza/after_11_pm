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

    it 'returns false for 0=3x-4x^2+3x^3-5' do
      equation = '0=3x^2-4x^3+3x-5'.objectify
      expect(equation.is_quadratic?).to eq false
    end

    it 'returns false for 0=3x-4x+3x^3-5' do
      equation = '0=3x-4x^3+3x-5'.objectify
      expect(equation.is_quadratic?).to eq false
    end

    it 'returns true for 2x^2-3=2x-4x+3x^2-5' do
      equation = '2x^2-3x+4-x=2x-4x+3x^2-5'.objectify
      expect(equation.is_quadratic?).to eq true
    end

    it 'returns true for 2y^2x^4-3=2x^2y-4' do
      equation = '2y^2x^4-3=2x^2y-4'.objectify
      expect(equation.is_quadratic?).to eq true
    end

    it 'returns true for 2(\sin x)^2x^4-3=2x^2\sin x-4' do
      equation = '2(\sin x)^2x^4-3=2x^2\sin x-4'.objectify
      expect(equation.is_quadratic?).to eq true
    end

    #will work once combine brackets work (x^2)^2 -> x^4
    xit 'returns true for 2y^{-2}-3=2y^{-1}-4' do
      equation = '2y^{-2}-3=2y^{-1}-4'.objectify
      expect(equation.is_quadratic?).to eq true
    end
  end

  describe '#quadratic_var' do
    it 'returns x as var for 0=2x^2-4x+3' do
      equation = '0=2x^2-4x+3'.objectify
      expect(equation.quadratic_var).to eq 'x'
    end

    it 'returns x^2\sin x for 2(\sin x)^2x^4-3=2x^2\sin x-4' do
      equation = '2(\sin x)^2x^4-3=2x^2\sin x-4'.objectify
      expect(equation.quadratic_var).to eq 'x^2\sin x'.objectify
    end

    it 'returns nil for 0=3x-4x+3x^3-5' do
      equation = '0=3x-4x^3+3x-5'.objectify
      expect(equation.quadratic_var).to eq nil
    end
  end


end
