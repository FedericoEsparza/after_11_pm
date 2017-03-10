# require './helpers/latex_utilities'

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
      exp = add(["x"])
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq add('x')
    end

    it '' do
      exp = add('x',mtp(-3,'y'),mtp(2,'y'))
      result = dummy_class.conventionalise_plus_minus(exp)
      expect(result).to eq add(sbt('x',mtp(3,'y')),mtp(2,'y'))
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

    it '' do
      exp = add(-3,4,5)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq add(sbt(nil,3),4,5)
    end

    it '' do
      exp = mtp(-2,'y')
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(nil,mtp(2,'y'))
    end

    it '' do
      exp = add(2,frac(3,4))
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq add(2,frac(3,4))
    end

    it '' do
      exp = add(2,frac(3,4,sign: :-))
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(2,frac(3,4))
    end

    it '' do
      exp = mtp(frac(3,4,sign: :-),'x')
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(nil,mtp(frac(3,4),'x'))
    end

    it '' do
      exp = add('x',mtp(frac(2,3),'y'),mtp(frac(4,5,sign: :-),'y'))
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(add('x',mtp(frac(2,3),'y')),mtp(frac(4,5),'y'))
    end

    it '' do
      exp = mtp(-1,'x')
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(nil,mtp(1,'x'))
    end

    it '' do
      exp = add(mtp(-1,'x'),-2)
      expect(dummy_class.conventionalise_plus_minus(exp)).to eq sbt(sbt(nil,mtp(1,'x')),2)
    end
  end

  describe '#conventionalise_one_times' do
    it '' do
      exp = mtp(1,'x')
      expect(dummy_class.conventionalise_one_times(exp)).to eq mtp('x')
    end

    it '' do
      exp = mtp(1,'x','y')
      expect(dummy_class.conventionalise_one_times(exp)).to eq mtp('x','y')
    end

    it '' do
      exp = mtp(1,'x',mtp(1,'a','b'))
      expect(dummy_class.conventionalise_one_times(exp)).to eq mtp('x',mtp('a','b'))
    end

    it '' do
      exp = add(2,'x',mtp(1,'a','b'))
      expect(dummy_class.conventionalise_one_times(exp)).to eq add(2,'x',mtp('a','b'))
    end

    it '' do
      exp = add(2,3,4,sbt(3,div(2,'x',mtp(1,'a','b'))))
      expect(dummy_class.conventionalise_one_times(exp)).to eq add(2,3,4,sbt(3,div(2,'x',mtp('a','b'))))
    end
  end

  describe 'conventionalise' do
    it '' do
      exp = mtp(-1,'x','y')
      expect(dummy_class.conventionalise(exp)).to eq sbt(nil,mtp('x','y'))
    end

    it '' do
      exp = add('x',2)
      expect(dummy_class.conventionalise(exp)).to eq add('x',2)
    end

    it '' do
      exp = add(mtp(1,pow('x',2)),mtp(-3,'x'),-4)
      expect(dummy_class.conventionalise(exp)).to eq sbt(sbt(mtp(pow('x',2)),mtp(3,'x')),4)
    end

    it '' do
      exp = mtp(-1,'x')
      expect(dummy_class.conventionalise(exp)).to eq sbt(nil,mtp('x'))
    end

    it '' do
      exp = cos(mtp(-1,'x'))
      expect(dummy_class.conventionalise(exp)).to eq cos(sbt(nil,mtp('x')))
    end

    it '' do
      exp = add(9,div(36,add(mtp(7,'x'),-2)))
      expect(dummy_class.conventionalise(exp)).to eq add(9,div(36,sbt(mtp(7,'x'),2)))
    end

    it '' do
      exp = add(mtp(2,pow('x',2)),mtp(-3,'x'),-4)
      expect(dummy_class.conventionalise(exp)).to eq sbt(sbt(mtp(2,pow('x',2)),mtp(3,'x')),4)
    end

    it '' do
      exp = add(mtp(2,pow('x',2)),mtp(-9,'x'),7)
      expect(dummy_class.conventionalise(exp)).to eq add(sbt(mtp(2,pow('x',2)),mtp(9,'x')),7)
    end

    it '' do
      exp = sin(add(100,mtp(-2,'x')))
      expect(dummy_class.conventionalise(exp)).to eq sin(sbt(100,mtp(2,'x')))
    end

  end
end
