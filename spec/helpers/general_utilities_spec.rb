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

  context '#depth' do
    it 'get tree (array) depth of exp' do
      exp = add(add(3,2), 3)
      expect(dummy_class.depth(exp)).to eq 1
    end

    it 'get tree (array) depth of exp' do
      exp = mtp(1, 'x')
      expect(dummy_class.depth(exp)).to eq 0
    end

    it 'get tree (array) depth of exp' do
      exp = add(mtp(-1, add(3, 2)), 3)
      expect(dummy_class.depth(exp)).to eq 2
    end

    it 'get tree (array) depth of array' do
      exp = [[[[]]], [[[[]]]]]
      expect(dummy_class.depth(exp)).to eq 4
    end
  end

  context '#tree_to_array' do
    it 'return arguments of an exp as array' do
      exp = mtp(1, 'x')
      expect(dummy_class.tree_to_array(exp)).to eq [1, 'x']
    end

    it 'return arguments of an exp as array' do
      exp = add(mtp(-1, add(3, 2)), 3)
      expect(dummy_class.tree_to_array(exp)).to eq [[-1, [3, 2]], 3]
    end
  end

  context '#includes?' do
    context 'looking for Division' do
      it 'return true for 2/3' do
        exp = div(2, 3)
        expect(dummy_class.includes?(Division, object: exp)).to be true
      end

      it 'return true for 2(2+2x/x)' do
        exp = mtp(2, add(2, div(mtp(2, 'x'), 'x')))
        expect(dummy_class.includes?(Division, object: exp)).to be true
      end

      it 'return false for 2x' do
        exp = mtp(2, 'x')
        expect(dummy_class.includes?(Division, object: exp)).to be false
      end
    end

    context 'looking for Multiplication' do
      it 'return false for 2/3' do
        exp = div(2, 3)
        expect(dummy_class.includes?(Multiplication, object: exp)).to be false
      end

      it 'return true for 2(2+2x/x)' do
        exp = mtp(2, add(2, div(mtp(2, 'x'), 'x')))
        expect(dummy_class.includes?(Multiplication, object: exp)).to be true
      end
    end
  end
end
