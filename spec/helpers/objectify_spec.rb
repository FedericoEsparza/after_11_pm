require './helpers/objectify'

describe Objectify do
  let(:dummy_class){(Class.new{include Objectify}).new}

  describe '#objectify' do
    it '' do
      expect(dummy_class.objectify('x+2')).to eq add('x',2)
    end
  end

end
