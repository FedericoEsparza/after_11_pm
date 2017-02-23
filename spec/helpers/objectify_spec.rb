require './helpers/objectify'

describe Objectify do
  let(:dummy_class){(Class.new{include Objectify}).new}

  describe '#objectify' do
    it 'x+2' do
      expect(dummy_class.objectify('x+2')).to eq add('x',2)
    end

    it 'x+y+2' do
      expect(dummy_class.objectify('x+y+2')).to eq add('x','y',2)
    end

    it '2x' do
      expect(dummy_class.objectify('2x')).to eq mtp(2,'x')
    end

    it '3xyz' do
      expect(dummy_class.objectify('3xyz')).to eq mtp(3,'x','y','z')
    end

    it '3x+5' do
      expect(dummy_class.objectify('3x+5')).to eq add(mtp(3,'x'),5)
    end
  end

end
