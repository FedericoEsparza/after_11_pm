require './helpers/latex_utilities'

describe LatexUtilities do
  let(:dummy_class){(Class.new{include LatexUtilities}).new}

  describe '#conventionalise' do
    it '' do
      exp = add('x',2,3)
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.conventionalise(exp)).to eq add('x',2,3)
    end

    it '' do
      exp = add('x',2,-3)
      expect(dummy_class.conventionalise(exp)).to eq sbt(add('x',2),3)
    end

    it '' do
      exp = add('x',2,-3,4,5)
      expect(dummy_class.conventionalise(exp)).to eq add(sbt(add('x',2),3),4,5)
    end

    it '' do
      exp = add('x',2,-3,4,5,-6,7,8)
      expect(dummy_class.conventionalise(exp)).to eq add(sbt(add(sbt(add('x',2),3),4,5),6),7,8)
    end

    it '' do
      exp = add('x',-2,-3,-4)
        expect(dummy_class.conventionalise(exp)).to eq sbt(sbt(sbt('x',2),3),4)
    end

    it '' do
      exp = add('x',-2)
        expect(dummy_class.conventionalise(exp)).to eq sbt('x',2)
    end

  end
end
