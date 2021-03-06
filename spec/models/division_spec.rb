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

  describe '#simplify' do
    it '\frac{6x}{8y} where common factor of two numbers are cancelled' do
      exp = '\frac{6x}{8y}'.objectify
      expect(exp.simplify).to eq '\frac{3x}{4y}'.objectify
    end

    it '\frac{6x}{3yz} bot number divided out' do
      exp = '\frac{6x}{3yz}'.objectify
      expect(exp.simplify).to eq '\frac{2x}{yz}'.objectify
    end

    it '\frac{3xw}{6yz} bot number divided out' do
      exp = '\frac{3xw}{6yz}'.objectify
      expect(exp.simplify).to eq '\frac{xw}{2yz}'.objectify
    end

    it '\frac{3xw}{yz} bot no num' do
      exp = '\frac{3xw}{yz}'.objectify
      expect(exp.simplify).to eq '\frac{3xw}{yz}'.objectify
    end

    it '\frac{3xw}{yz} bot no num' do
      exp = '\frac{3xw}{3yz}'.objectify
      expect(exp.simplify).to eq '\frac{xw}{yz}'.objectify
    end

    it '\frac{6x^4}{8x^2y} power cancellation top left with power' do
      exp = '\frac{6x^4}{8x^2y}'.objectify
      expect(exp.simplify).to eq '\frac{3x^2}{4y}'.objectify
    end

    it '\frac{6x^3}{8x^2y} power cancel top left with str-var' do
      exp = '\frac{6x^3}{8x^2y}'.objectify
      expect(exp.simplify).to eq '\frac{3x}{4y}'.objectify
    end

    it '\frac{3x^3}{4xy} top power bot string var cancel' do
      exp = '\frac{3x^3}{4xy}'.objectify
      expect(exp.simplify).to eq '\frac{3x^2}{4y}'.objectify
    end

    it '\frac{3ax^2}{4x^5y} top string bot power var cancel' do
      exp = '\frac{3ax^2}{4x^5y}'.objectify
      expect(exp.simplify).to eq '\frac{3a}{4x^3y}'.objectify
    end

    it '\frac{3ax^2}{4x^2y} cancel completely' do
      exp = '\frac{3ax^2}{4x^2y}'.objectify
      expect(exp.simplify).to eq '\frac{3a}{4y}'.objectify
    end

    it '\frac{x}{3} string and numeral top and bot' do
      exp = '\frac{x}{3}'.objectify
      expect(exp.simplify).to eq '\frac{x}{3}'.objectify
    end

    it '\frac{x^2}{x} string and numeral top and bot' do
      exp = '\frac{x^2}{x}'.objectify
      expect(exp.simplify).to eq 'x'
    end

    it '\frac{x^2}{2x^4y} string and numeral top and bot' do
      exp = '\frac{x^2}{2x^4y}'.objectify
      expect(exp.simplify).to eq '\frac{1}{2x^2y}'.objectify
    end

    it '\frac{x^2}{x^2} string and numeral top and bot' do
      exp = '\frac{x^2}{x^2}'.objectify
      expect(exp.simplify).to eq 1
    end
  end
end
