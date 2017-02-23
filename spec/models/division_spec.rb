describe Division do
  describe '#initialize' do
    it 'initialise with top_side and bottom_side' do
      exp = div('x',3)
      expect(exp.top).to eq 'x'
      expect(exp.bot).to eq 3
    end
  end

  describe 'setters for top and bot' do
    it 'setter for top' do
      exp = div('x',3)
      exp.top = 'y'
      expect(exp.top).to eq 'y'
    end

    it 'setter for bot' do
      exp = div('x',3)
      exp.bot = 4
      expect(exp.bot).to eq 4
    end
  end
end
