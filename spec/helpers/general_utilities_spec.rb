describe GeneralUtilities do
  let(:dummy_class){(Class.new{include GeneralUtilities}).new}

  describe '#flatten' do
    it '' do
      exp = add(add('x',2,3))
      expect(dummy_class.flatten(exp)).to eq add('x',2,3)
    end

    it '' do
      exp = add(add('x',2,add(3)))
      expect(dummy_class.flatten(exp)).to eq add('x',2,3)
    end

    it '' do
      exp = add(add('x',2,div(mtp(2), 3)))
      expect(dummy_class.flatten(exp)).to eq add('x',2,div(2, 3))
    end

    it '' do
      exp = sin(add(add('x',2,div(mtp(2), 3))))
      expect(dummy_class.flatten(exp)).to eq sin(add('x',2,div(2, 3)))
    end

    it '' do
      exp = pow(2,sin(add(add('x',2,div(mtp(add(2)), 3)))))
      expect(dummy_class.flatten(exp)).to eq pow(2, sin(add('x',2,div(2, 3))))
    end

    it '' do
      exp = 'x'
      expect(dummy_class.flatten(exp)).to eq 'x'
    end

    it '' do
      exp = 1
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
      expect(exp.flatten).to eq 1
    end

    it 'x' do
      exp = 'x'
      expect(exp.flatten).to eq 'x'
    end
  end

  describe '#write test' do
    it 'writes a test eg 1' do
      result_steps = [mtp(2,pow('x',3)),add(5,div('y',4))]
      expect(write_test(result_steps)).to eq "expect(result).to eq [\n  '2x^3'.objectify,\n  '5+\\frac{y}{4}'.objectify\n]"
    end
  end

  describe '#is_m_form?' do
    it 'true for 3xyz' do
      exp = '3xyz'.objectify
      expect(exp.is_m_form?).to eq true
    end

    it 'false for 3(x+2)yz' do
      exp = '3(x+2)yz'.objectify
      expect(exp.is_m_form?).to eq false
    end

    it 'true for 3a^3yz' do
      exp = '3a^3yz'.objectify
      expect(exp.is_m_form?).to eq true
    end

    it 'false for 3(a+2)^3yz' do
      exp = '3(a+2)^3yz'.objectify
      expect(exp.is_m_form?).to eq false
    end

    it 'false for 3(2+\sin x)^3yz' do
      exp = '3(2+\sin x)^3yz'.objectify
      expect(exp.is_m_form?).to eq false
    end

    it 'true for 3(\sin x)^3yz' do
      exp = '3(\sin x)^3yz'.objectify
      expect(exp.is_m_form?).to eq true
    end
  end
end
