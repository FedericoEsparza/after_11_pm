require './models/arc_cosine'

describe ArcCosine do
  describe '#evaluate_numeral' do
    it 'evaluates arccos(0.5)' do
      expect(arccos(0.5).evaluate_numeral).to eq 60
    end

    it 'evaluates arccos(sqrt(3)/2) to 60 (we make surds later!)' do
      expect(arccos(Math.sqrt(3)/2).evaluate_numeral).to eq 30
    end

    it 'evaluates arccos(0.7)' do
      expect(arccos(0.7).evaluate_numeral).to eq 45.573
    end

    it 'evaluates arccos(0)' do
      expect(arccos(0).evaluate_numeral).to eq 90
    end
  end
end
