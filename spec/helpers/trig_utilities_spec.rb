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

    it 'find the first trig angle for 3+2\tan y' do
      exp = '3+2\tan y'.objectify
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
    it '3x-4 returns true' do
      exp = '3x-4'.objectify
      expect(dummy_class.same_angles?(exp)).to eq false
    end

    it '3+sin x+ tan x returns true' do
      exp = '3+\sin y+\tan y'.objectify
      expect(dummy_class.same_angles?(exp)).to eq true
    end

    it '3+tan y+cos x returns false' do
      exp = '3+\tan y+\cos x'.objectify
      expect(dummy_class.same_angles?(exp)).to eq false
    end

    it '3+sin y+2cos x returns false' do
      exp = '3+\sin y+2\cos x'.objectify
      expect(dummy_class.same_angles?(exp)).to eq false
    end

    it '5-\frac{3+2\sin y}{2+\tan y} returns true' do
      exp = '5-\frac{3+2\sin y}{2+\tan y}'.objectify
      expect(dummy_class.same_angles?(exp)).to eq true
    end

    it '5-\frac{3+2\tan y}{2+\cos 2y} returns false' do
      exp = '5-\frac{3+2\tan y}{2+\cos 2y}'.objectify
      expect(dummy_class.same_angles?(exp)).to eq false
    end

    it '5-\frac{3+2\tan y^2}{2+\cos y^2} returns true' do
      exp = '5-\frac{3+2\tan y^2}{2+\cos y^2}'.objectify
      expect(dummy_class.same_angles?(exp)).to eq true
    end
  end

  describe '#fix_nums_to_one' do
    it 'fixes 3+2 to 1+1' do
      exp = '3+2'.objectify
      result = dummy_class.fix_nums_to_one(exp)
      expect(result).to eq '1+1'.objectify
      expect(result.object_id).not_to eq exp.object_id
    end

    it 'fixes 5-\frac{3+2\tan y^2}{2+\cos y^2}' do
      exp = '5-\frac{3+2\tan y^2}{2+\cos y^2}'.objectify
      result = dummy_class.fix_nums_to_one(exp)
      expect(result).to eq '1+(1\frac{1+1\tan y^2}{1+\cos y^2})'.objectify
      expect(result.object_id).not_to eq exp.object_id
    end

    it 'fixes z^3+2 to z^3' do
      exp = 'z^3+2'.objectify
      response = add(pow('z', 3), 1)
      expect(dummy_class.fix_nums_to_one(exp)).to eq response
    end

    it 'fixes z^3 to z^3' do
      exp = 'z^3'.objectify
      response = pow('z', 3)
      expect(dummy_class.fix_nums_to_one(exp)).to eq response
    end

    it 'fixes (3z)^3 to z^3' do
      exp = '(3z)^3'.objectify
      response = pow(mtp(1,'z'), 3)
      expect(dummy_class.fix_nums_to_one(exp)).to eq response
    end
  end

  describe '#fix_angles_to_x' do
    it 'fixes \sin 2x to \sin x' do
      exp = '\sin 2x'.objectify
      result = dummy_class.fix_angles_to_x(exp)
      expect(result).to eq '\sin x'.objectify
      expect(result.object_id).not_to eq exp.object_id
    end

    it 'fixes 5-\frac{3+2\tan y^2}{2+\cos y^2}' do
      exp = '5-\frac{3+2\tan y^2}{2+\cos y^2}'.objectify
      result = dummy_class.fix_angles_to_x(exp)
      expect(result).to eq '5-\frac{3+2\tan x}{2+\cos x}'.objectify
      expect(result.object_id).not_to eq exp.object_id
    end
  end

end
