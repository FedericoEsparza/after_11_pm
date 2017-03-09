require './helpers/trig_utilities'

describe TrigUtilities do
  let(:dummy_class){(Class.new{include TrigUtilities}).new}

  describe '#same_angles?' do
    it '3+sin x+2cos x returns true' do
      exp = '3+\sin y+2\cos y'.objectify
      expect(dummy_class.same_angles?(exp)).to eq true
    end
  end

end
