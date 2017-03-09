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

  describe '#expand' do
    it 'expands 2(14-4y)/5' do
      exp = div(mtp(2,add(14,mtp(-4,'y'))),5)
      result = exp.expand
      expect(result).to eq []
    end
  end
end
