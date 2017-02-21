require './models/arc_sine'

describe ArcSine do
  describe '#initialize' do
    it 'initialise with a value' do
      exp = arcsin(0.5)
      expect(exp.value).to eq 0.5
    end

    it 'can init with array' do
      exp = arcsin([0.5])
      expect(exp.value).to eq 0.5
    end
  end

  describe 'setters for value' do
    it 'setter for value' do
      exp = arcsin(0.5)
      exp.value = 0.6
      expect(exp.value).to eq 0.6
    end
  end

  describe '#evaluate_numeral' do
    it 'evaluates arcsin(0.5)' do
      expect(arcsin(0.5).evaluate_numeral).to eq 30
    end

    it 'evaluates arcsin(sqrt(3)/2) to 60 (we make surds later!)' do
      expect(arcsin(Math.sqrt(3)/2).evaluate_numeral).to eq 60
    end

    it 'evaluates arcsin(0.7)' do
      expect(arcsin(0.7).evaluate_numeral).to eq 44.4270040008057
    end
  end
end
