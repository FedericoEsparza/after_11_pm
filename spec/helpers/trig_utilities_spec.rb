require './helpers/trig_utilities'

describe TrigUtilities do
  let(:dummy_class){(Class.new{include TrigUtilities}).new}

  describe '#first_trig_angle' do
    it 'find the first trig angle for 3+\sin y+\cos y' do
      exp = '3+\sin y+\cos y'.objectify
      expect(dummy_class.first_trig_angle(exp)).to eq 'y'
    end

    it 'find the first trig angle for 3+2\sin y' do
      exp = '3+2\sin y'.objectify
      expect(dummy_class.first_trig_angle(exp)).to eq 'y'
    end

    it 'recursively find the first trig angle for 5-\frac{3+2\sin y}{2+x}' do
      exp = '5-\frac{3+2\sin y}{2+x}'.objectify
      expect(dummy_class.first_trig_angle(exp)).to eq 'y'
    end

    it 'returns nil for 5-\frac{3+2y}{2+x}' do
      exp = '5-\frac{3+2y}{2+x}'.objectify
      expect(dummy_class.first_trig_angle(exp)).to eq nil
    end
  end

  describe '#same_angles?' do
    it '3+sin x+ cos x returns true' do
      exp = '3+\sin y+\cos y'.objectify
      expect(dummy_class.same_angles?(exp)).to eq true
    end

    it '3+sin y+cos x returns false' do
      exp = '3+\sin y+\cos x'.objectify
      expect(dummy_class.same_angles?(exp)).to eq false
    end

    xit '3+sin y+cos x returns false' do
      exp = '3+\sin y+2\cos x'.objectify
      expect(dummy_class.same_angles?(exp)).to eq false
    end
  end




end
