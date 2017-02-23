describe Sine do
  describe '#initialize' do
    it 'initialise with angle in degrees' do
      exp = sin(60)
      expect(exp.angle).to eq 60
    end

    it 'can init with array' do
      exp = sin([60])
      expect(exp.angle).to eq 60
    end
  end

  describe 'setters for angle' do
    it 'setter for angle' do
      exp = sin(60)
      exp.angle = 70
      expect(exp.angle).to eq 70
    end
  end

  describe '#evaluate_numeral' do
    it 'evaluates sin(30)' do
      expect(sin(30).evaluate_numeral).to eq 0.5
    end

    it 'evaluates sin(60) to 0.86603 (we make surds later!)' do
      expect(sin(60).evaluate_numeral).to eq 0.86603
    end
  end
end
