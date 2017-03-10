describe GeneralUtilities do
  let(:dummy_class){(Class.new{include GeneralUtilities}).new}

  describe '#flatten' do
    it '' do
      exp = add(add('x',2,3))
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.flatten(exp)).to eq add('x',2,3)
    end

    it '' do
      exp = add(add('x',2,add(3)))
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.flatten(exp)).to eq add('x',2,3)
    end

    it '' do
      exp = add(add('x',2,div(mtp(2), 3)))
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.flatten(exp)).to eq add('x',2,div(2, 3))
    end

    it '' do
      exp = sin(add(add('x',2,div(mtp(2), 3))))
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.flatten(exp)).to eq sin(add('x',2,div(2, 3)))
    end

    it '' do
      exp = pow(2,sin(add(add('x',2,div(mtp(add(2)), 3)))))
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.flatten(exp)).to eq pow(2, sin(add('x',2,div(2, 3))))
    end

    it '' do
      exp = 'x'
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.flatten(exp)).to eq 'x'
    end

    it '' do
      exp = 1
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(dummy_class.flatten(exp)).to eq 1
    end
  end

  context 'call #flatten from class' do
    it '' do
      exp = add(add(3),3)
      expect(exp.flatten).to eq add(3, 3)
    end

    it '' do
      exp = eqn(add(mtp(3, 'x')), -5)
      expect(exp.flatten).to eq eqn(mtp(3, 'x'), -5)
    end

    it '' do
      exp = 1
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(exp.flatten).to eq 1
    end

    it 'x' do
      exp = 'x'
      # puts add(sbt(add('x',2),3),4,5).latex
      expect(exp.flatten).to eq 'x'
    end
  end
end
