require './helpers/latex_utilities'

describe LatexUtilities do
  let(:dummy_class){(Class.new{include LatexUtilities}).new}

  describe '#conventionalise_plus_minus' do
    it '' do
      exp = add('x',2,3)
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq add('x',2,3)
    end

    it '' do
      exp = add('x',2,-3)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(add('x',2),3)
    end

    it '' do
      exp = add('x',2,-3,4,5)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq add(sbt(add('x',2),3),4,5)
    end

    it '' do
      exp = add('x',2,-3,4,5,-6,7,8)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq add(sbt(add(sbt(add('x',2),3),4,5),6),7,8)
    end

    it '' do
      exp = add('x',-2,-3,-4)
        expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(sbt(sbt('x',2),3),4)
    end

    it '' do
      exp = add('x',-2)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt('x',2)
    end

    it '' do
      exp = add('x',mtp(-2,'y'))
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt('x',mtp(2,'y'))
    end

    it '' do
      exp = add('x',mtp(3,'y'),mtp(-2,'y'))
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(add('x',mtp(3,'y')),mtp(2,'y'))
    end

    it '' do
      exp = mtp(2,'x',add(3,4,-5))
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq mtp(2,'x',sbt(add(3,4),5))
    end

    it '' do
      exp = sbt(2,add(3,4,-5))
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(2,sbt(add(3,4),5))
    end

    it '' do
      exp = div(add(3,4,-5),2)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq div(sbt(add(3,4),5),2)
    end

    it '' do
      exp = pow(add(3,4,-5),2)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq pow(sbt(add(3,4),5),2)
    end
  end
end
