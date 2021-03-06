describe Addition do
  describe '#initialize/new' do
    it 'initialize with an array of values to add' do
      addition = add(1,2,3)
      expect(addition.class).to eq described_class
      expect(addition.args).to eq [1,2,3]
    end
  end

  describe "#==" do
    it 'asserts equality when arguments are the same' do
      add_1 = add(1,2,'x')
      add_2 = add(1,2,'x')
      expect(add_1).to eq add_2
    end
  end

  describe '#evaluate' do
    it 'evaluates a sum of numbers' do
      addition = add(1,-2,3)
      expect(addition.evaluate).to eq 2
    end
  end

  # describe '#remove_exp' do
  #   it 'removes xy from 3xy' do
  #     addition = add(mtp(3,'x','y',4),mtp('x','y','z'))
  #     result = addition.args[0].remove_exp
  #     expect(result).to eq 12
  #   end
  # end

  # describe '#remove_coef' do
  #   it 'removes 3 from 3xy' do
  #   addition = mtp(3,'x','y',4)
  #   result = addition.remove_coef
  #   expect(result).to eq mtp('x','y')
  # end
  # end


  xdescribe '#simplify_add_m_forms' do

    it '#simplifies 3xy+2xy+xyz'do
    addition = add(mtp(3,'x','y'),mtp(2,'x','y'),mtp('x','y','z'))
    result = addition.simplify_add_m_forms
    expect(result).to eq add(mtp('x','y','z'),mtp(5,'x','y'))
    end
    #
    it '#simplifies 3xy+yx+x^2' do
    addition = add(mtp(3,'x','y'),mtp('y','x'),mtp(pow('x',2)))
    result = addition.simplify_add_m_forms
    expect(result).to eq add(mtp(pow('x',2)),mtp(4,'x','y'))
    end

    it '#simplifies x^2 + xy + yx + y^2' do
    addition = add(mtp(pow('x',2)),mtp('x','y'),mtp('y','x'),mtp(pow('y',2)))
    result = addition.simplify_add_m_forms
    expect(result).to eq add(mtp(pow('x',2)),mtp(2,'x','y'),mtp(pow('y',2)))
    end

    it '#simplifies x^2 + x^2 + y^2' do
      addition = add(mtp(pow('x',2)),mtp(pow('x',2)),mtp(pow('y',2)))
      result = addition.simplify_add_m_forms
      expect(result).to eq add(mtp(2,pow('x',2)),mtp(pow('y',2)))
    end

    xit '#simplifies x^2 + 4x + 4 + (x-2)' do
      addition = 'x^2 + 4x + 4 + x-2'.objectify.standardize_add_m_form
      result = addition.simplify_add_m_forms.flatit
      expect(result).to eq 'x^2 + 5x + 2'.objectify
    end

    it 'simplifies 25-10y+3y' do
      addition = add(mtp(25),mtp(-10,'y'),mtp(3,'y'))
      result = addition.simplify_add_m_forms
      expect(result).to eq add(mtp(-7,'y'),mtp(25))
    end
  end

  describe '#simplify_brackets' do
    it 'simplifies (x+y)(a+b) + (w+z)(c+d)' do
      exp = add(mtp(add('x','y'),add('a','b')),mtp(add('w','z'),add('c','d')))
      result = exp.simplify_brackets
      expect(result.last).to eq '(ax+bx+ay+by)+(cw+dw+cz+dz)'.objectify
    end

    it 'leaves x' do
      exp = add('x')
      result = exp.simplify_brackets
      expect(result).to eq add('x')
    end

    it 'simplifies x(x+y) + y' do
      exp = add(mtp('x',add('x','y')),'y')
      result = exp.simplify_brackets
      expect(result.last).to eq add(add(mtp(pow('x',2)),mtp('x','y')),'y')

      expect(result[0]).to eq add(mtp('x',add('x','y')),'y')
      expect(result[1]).to eq add(mtp(add('x'),add('x','y')),'y')
      expect(result[2]).to eq add(add(mtp(mtp('x'),mtp('x')),mtp(mtp('x'),mtp('y'))),'y')
      expect(result[3]).to eq add(add(mtp(mtp('x','x')),mtp('x','y')),'y')
      expect(result[4]).to eq add(add(mtp(mtp(pow('x',1),pow('x',1))),mtp('x','y')),'y')
      expect(result[5]).to eq add(add(mtp(pow('x',add(1,1))),mtp('x','y')),'y')
      expect(result[6]).to eq add(add(mtp(pow('x',2)),mtp('x','y')),'y')
    end
  end

  describe '#order_similar_terms' do
    it '2x + 3a + 4x -> 2x + 4x + 3a' do
      exp = add(mtp(2,'x'),mtp(3,'a'),mtp(4,'x'))
      result = exp.order_similar_terms
      expect(result).to eq add(mtp(2,'x'),mtp(4,'x'),mtp(3,'a'))
    end

    it '2xy^3+3a+b^3+4xy^3 -> ....' do
      exp = add(mtp(2,'x',pow('y',3)),mtp(3,'a'),mtp(pow('b',3)),mtp(4,'x',pow('y',3)),mtp(4,'a'),mtp(pow('b',5)))
      result = exp.order_similar_terms
      expect(result).to eq add(mtp(2,'x',pow('y',3)),mtp(4,'x',pow('y',3)),mtp(3,'a'),mtp(4,'a'),mtp(pow('b',3)),mtp(pow('b',5)))
    end

  end

  describe '#flatit' do
    it 'flats x+(x+xy) + ((x+y)+xz)' do
      exp = add('x',add('x',mtp('x','y')),add(add('x','y'),mtp('x','z')))
      result = exp.flatit
      expect(result).to eq add('x','x',mtp('x','y'),'x','y',mtp('x','z'))
    end
  end

  describe '#split_num' do
    it 'splits (x^2+6x+7)/5' do
      exp = frac(add(pow('x',2),mtp(6,'x'),7),5)
      result = exp.split_num

      expect(result).to eq add(frac(pow('x',2),5),frac(mtp(6,'x'),5),frac(7,5))

    end
  end

  describe '#elim_common_factors' do
    it 'simplifies x(x+1)/x' do
      exp = frac(mtp('x',add('x',1)),'x')
      result = exp.elim_common_factors

      expect(result).to eq add('x',1)
    end

    it 'simplifies (x-1)yz/xz(y-1)' do
      exp = frac(mtp(add('x',-1),'y','z'),mtp('x','z',add('y',-1)))
      result = exp.elim_common_factors
      expect(result).to eq frac(mtp(add('x',-1),'y'),mtp('x',add('y',-1)))
    end
  end

  describe '#~' do
    it 'returns true for 3+4 and 4+3' do
      exp_1 = add(3, 4)
      exp_2 = add(4,3)
      expect(exp_1.~(exp_2)).to be true
    end

    it 'returns true for x^2 +3 +5' do
      exp_1 = 'x^2+3+5'.objectify
      exp_2 = '3+5+x^2'.objectify
      expect(exp_1.~(exp_2)).to be true
    end

    it 'returns true for \sin x+y^2+z^{-3}' do
      exp_1 = '\sin x+(y^2+z^{-3})'.objectify
      exp_2 = '(z^{-3}+y^2)+\sin x'.objectify
      expect(exp_1.~(exp_2)).to be true
    end

    it 'returns false for \sin x+y^2+z^{-3}' do
      exp_1 = '\sin x+y^2+z^{-3}'.objectify
      exp_2 = '(z^{-3}+y^2)+\sin x'.objectify
      expect(exp_1.~(exp_2)).to be false
    end
  end


  describe '#find_common_factors' do
    it 'finds x(y+1)z^2 + x(y+1)^2z^3' do
      exp = 'x(y+1)z^2+x(y+1)^2z^3'.objectify
      result = exp.find_common_factors
      expect(result).to eq ['x',add('y',1),pow('z',2)]
    end

    it 'finds sinx(cosx+2)^2x^4 + sinx^2(cosx+2)x^6' do
      exp = '(\sin x)(\cos x+2)^2x^4+(\sin x)^2(\cos x+2)x^6'.objectify
      result = exp.find_common_factors
      expect(result).to eq [sin('x'),add(cos('x'),2),pow('x',4)]
    end

    it 'finds (x+2)^2x - (x+2)^3y' do
      exp = '(x+2)^2x-(x+2)^3y'.objectify
      result = exp.find_common_factors
      expect(result).to eq [pow(add('x',2),2)]
    end
  end

  describe '#divide_factors' do
    it 'divides x^2y^3(z-1)^4 by x^2y(z-1)' do
      exp = 'x^2y^3(z-1)^4'.objectify
      result = exp.divide_factors('x^2y(z-1)'.objectify)

      expect(result).to eq 'y^2(z-1)^3'.objectify
    end
  end

  describe '#factorise_common_factors' do
    it 'factorises x(y+1)z^2+x(y+1)^2z^3' do
      exp = 'x(y+1)z^2+x(y+1)^2z^3'.objectify
      result = exp.factorise_common_factors

      expect(result).to eq 'x(y+1)z^2(1+(y+1)z)'.objectify
    end

    it 'factorises xyz^2 + xyz^3' do
      exp = 'xyz^2-xyz^3'.objectify
      result = exp.factorise_common_factors
      expect(result).to eq 'xyz^2(1-z)'.objectify

    end

    it 'does not factorise (x+2)^2z + (x+2)^-1y' do
      exp = '(x+2)^2z+(x+2)^{-1}y'.objectify
      result = exp.factorise_common_factors
      expect(result).to eq '(x+2)^2z+(x+2)^{-1}y'.objectify
    end
  end


end
