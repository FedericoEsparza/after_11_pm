require './models/arc_tangent'

describe ArcTangent do
  describe '#evaluate_numeral' do
    it 'evaluates arctan(0.5)' do
      expect(arctan(0.5).evaluate_numeral).to eq 26.56505
    end

    it 'evaluates arctan(sqrt(3)/2) to 60 (we make surds later!)' do
      expect(arctan(Math.sqrt(3)/3).evaluate_numeral).to eq 30
    end

    it 'evaluates arctan(0.7)' do
      expect(arctan(0.7).evaluate_numeral).to eq 34.99202
    end

    it 'evaluates arctan(0)' do
      expect(arctan(0).evaluate_numeral).to eq 0
    end
  end
end
