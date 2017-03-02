require './helpers/latex_utilities'

describe LatexUtilities do
  let(:dummy_class){(Class.new{include LatexUtilities}).new}

  describe '#conventionalise' do
    it '' do
      exp = add('x',2,-3,4,5)
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.conventionalise(exp)).to eq add(sbt(add('x',2),3),4,5)
    end
  end
end
