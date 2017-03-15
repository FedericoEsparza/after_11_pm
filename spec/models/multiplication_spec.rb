describe Multiplication do
  describe '#initialize/new' do
    it 'initialize with an array of values to multiply' do
      multiplication = mtp(1,2,3)
      expect(multiplication.class).to eq described_class
      expect(multiplication.args).to eq [1,2,3]
    end
  end

  describe "#==" do
    it 'asserts equality when arguments are the same' do
      mtp_1 = mtp(1,2,'x')
      mtp_2 = mtp(1,2,'x')
      expect(mtp_1).to eq mtp_2
    end

    it 'asserts equality when exp arguments are the same' do
      mtp_1 = mtp(1,add(1,'y'),'x')
      mtp_2 = mtp(1,add(1,'y'),'x')
      expect(mtp_1).to eq mtp_2
    end

    it 'asserts inequality when exp arguments are the same' do
      mtp_1 = mtp(1,2,3)
      mtp_2 = mtp(1,2,)
      expect(mtp_1).not_to eq mtp_2
    end
  end

  describe '#~' do
    it 'returns true for xyz ~ yzx' do
      exp_1 = 'xyz'.objectify
      exp_2 = 'yzx'.objectify
      expect(exp_1.~(exp_2)).to be true
    end

    it 'returns true for xyz ~ yzx' do
      exp_1 = '(x+2)(y-3)(z+4)'.objectify
      exp_2 = '(z+4)(-3+y)(2+x)'.objectify
      expect(exp_1.~(exp_2)).to be true
    end

    it 'returns true for xyz ~ yzx' do
      exp_1 = '(x+2)(3-2y)(z+4)'.objectify
      exp_2 = '(z+4)(-2y+3)(2+x)'.objectify
      expect(exp_1.~(exp_2)).to be true
    end

    it 'returns true for this' do
      exp_1 = '(\sin x)^2-5+2\sin x'.objectify
      exp_2 = '-5+2\sin x+(\sin x)^2'.objectify
      expect(exp_1.~(exp_2)).to be true
    end
  end

  describe '#>' do
    it 'checks y > z' do
      mtp_1 = 'y'
      mtp_2 = 'z'
      result = mtp_1.greater?(mtp_2)
      expect(result).to eq true
    end

    it 'checks x^2(y+x) > x^2(y+x^2)' do
      mtp_1 = mtp(pow('x',2),add('y','x'))
      mtp_2 = mtp(pow('x',2),add('y',pow('x',2)))
      result = mtp_1.greater?(mtp_2)
      expect(result).to eq false
    end

    it 'checks x^3(y+x) > x^2(y+x^2)' do
      mtp_1 = mtp(pow('x',3),add('y','x'))
      mtp_2 = mtp(pow('x',2),add('y',pow('x',2)))
      result = mtp_1.greater?(mtp_2)
      expect(result).to eq true
    end

    it 'checks 4x > 4y' do
      mtp_1 = mtp(4,'x')
      mtp_2 = mtp(4,'y')
      result = mtp_1.greater?(mtp_2)
      expect(result).to eq true
    end
  end

  describe '#copy' do
    it 'copies mtp(x,y)' do
      exp = mtp('x','y')
      copy_of_exp = exp.copy
      expect(copy_of_exp).to eq exp
      expect(copy_of_exp.object_id).not_to eq exp.object_id
    end

    it 'creates a deep copy of mtp(mtp(x,y),mtp(w,z))' do
      exp = mtp(mtp('x','y'),mtp('w','z'))
      copy_of_exp = exp.copy
      expect(copy_of_exp).to eq exp
      expect(copy_of_exp.object_id).not_to eq exp.object_id
      expect(copy_of_exp.args[0].object_id).not_to eq exp.args[0].object_id
      expect(copy_of_exp.args[1].object_id).not_to eq exp.args[1].object_id
    end
  end

  describe '#convert_to_power' do
    it 'converts string arguments to power of one' do
      exp = mtp(2,'x','y')
      exp.convert_to_power
      expect(exp.args).to eq [2,pow('x',1),pow('y',1)]
    end
  end

  describe '#depower' do
    it 'converts power one arguments to base' do
      exp = mtp(2,pow(add(3,'x'),1),'y')
      exp.depower
      expect(exp.args).to eq [2,add(3,'x'),'y']
    end
  end

  describe '#combine_powers' do
    it 'combines x^2 times x^3' do
      exp = mtp(pow('x',2),pow('x',3))
      expect(exp.combine_powers).to eq [
        # mtp(pow('x',2),pow('x',3)),
        pow('x',5)
      ]
    end

    it 'leaves x alone' do
      exp = mtp('x')
      expect(exp.combine_powers).to eq [
        'x'
      ]
    end

    it 'combines y^3 times y^-2' do
      exp = mtp(pow('y',3),pow('y',-2))
      expect(exp.combine_powers).to eq [
      # mtp(pow('y',3),pow('y',-2)),
      'y'
      ]
    end

    it 'combines x times x^2' do
      exp = mtp('x',pow('x',2))
      expect(exp.combine_powers).to eq [
        # mtp('x',pow('x',2)),
        pow('x',3)
      ]
    end

    it 'combine y times y^3 times y^-2' do
      exp = mtp('y',pow('y',3),pow('y',-2))
      expect(exp.combine_powers).to eq [
        # mtp('y',pow('y',3),pow('y',-2)),
        pow('y',2)
      ]
    end

    it 'combines 3 times 4 times 5' do
      exp = mtp(3,4,5)
      expect(exp.combine_powers).to eq [
        # mtp(3,4,5),
        60
      ]
    end

    it 'combines 3 times 2^2 times 5' do
      exp = mtp(3,pow(2,2),5)
      expect(exp.combine_powers).to eq [
        # mtp(3,pow(2,2),5),
        60
      ]
    end

    it 'combine y times y^2 times y^-3' do
      exp = mtp('y',pow('y',2),pow('y',-3))
      expect(exp.combine_powers).to eq [
        # mtp('y',pow('y',2),pow('y',-3)),
        nil
      ]
    end
  end

  describe '#delete_arg' do
    it 'deletes the 2nd arg and returns it' do
      exp = mtp(1,2,3,4)
      result = exp.delete_arg(2)
      expect(exp).to eq mtp(1,3,4)
      expect(result).to eq 2
    end
  end

  describe '#delete_empty_args' do
    it 'delete one empty arg' do
      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp())
      exp.delete_empty_args
      expect(exp).to eq mtp(mtp(pow('x',2),pow('y',3)))
    end

    it 'delete all empty arg' do
      exp = mtp(mtp(),mtp())
      exp.delete_empty_args
      expect(exp).to eq mtp()
    end
  end

  describe '#separate variables' do
    it 'separates (x^2y^3)(x^4y^5) as (x^2x^4)(y^3y^5)' do
     exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
     result  = exp.separate_variables
     expect(exp).to eq mtp(mtp(pow('x',2),pow('x',4)),mtp(pow('y',3),pow('y',5)))
     expect(result).to eq mtp(mtp(pow('x',2),pow('x',4)),mtp(pow('y',3),pow('y',5)))
    end

    it 'separates (3x^2)(4xy^2) as (3 4)(x^2x)(y^2)' do
     exp = mtp(mtp(3,pow('x',2)),mtp(4,'x',pow('y',2)))
     result = exp.separate_variables
     expect(exp).to eq mtp(mtp(3,4),mtp(pow('x',2),'x'),mtp(pow('y',2)))
     expect(result).to eq mtp(mtp(3,4),mtp(pow('x',2),'x'),mtp(pow('y',2)))
    end

    it 'separates (3x^2)(4xy^2) as (3 4)(x^2x)(y^2)' do
     exp = mtp(mtp(3,'x'),mtp(4,pow('x', 2),pow('y',2)))
     result = exp.separate_variables
     expect(exp).to eq mtp(mtp(3,4),mtp('x',pow('x', 2)),mtp(pow('y',2)))
     expect(result).to eq mtp(mtp(3,4),mtp('x',pow('x', 2)),mtp(pow('y',2)))
    end

    it 'separates (3^2x^2)(4x) as (3^2 4)(x^2x)' do
     exp = mtp(mtp(pow(3,2),pow('x',2)),mtp(4,'x'))
     result = exp.separate_variables
     expect(exp).to eq mtp(mtp(pow(3,2),4),mtp(pow('x', 2),'x'))
     expect(result).to eq mtp(mtp(pow(3,2),4),mtp(pow('x', 2),'x'))
    end

    it 'separates (x^2)(3x)(4xy)' do
     exp = mtp(mtp(pow('x',2)),mtp(3,'x'),mtp(4,'x','y'))
     result = exp.separate_variables
     expect(exp).to eq mtp(mtp(pow('x',2),'x','x'),mtp(3,4),mtp('y'))
    end
  end

  describe '#evaluate_numeral' do
    it 'evaluates to a product of the arguments' do
     multiplication = mtp(1,-2,3)
     expect(multiplication.evaluate_numeral).to eq -6
    end
  end

  describe '#simplify_product_of_m_forms' do
    it 'simplifies (3x^2y3)(3xy^4) to 9x^3y^7' do
     exp = mtp(mtp(3,pow('x',2),pow('y',3)),mtp(3,'x',pow('y',4)))
     result = exp.simplify_product_of_m_forms
      # puts write_test(result)
      expect(result).to eq [
        '(3x^2y^3)(3xy^4)'.objectify,
        '9x^3y^7'.objectify
      ]
    end

    it 'simplifies (3x)(4y)(5z) to 60xyz' do
      exp = mtp(mtp(3,'x'),mtp(4,'y'),mtp(5,'z'))
      result = exp.simplify_product_of_m_forms
      # puts write_test(result)
      expect(result).to eq [
        '(3x)(4y)(5z)'.objectify,
        '60xyz'.objectify
      ]
    end

    it 'simplifies (3y^3z)(2^2y^-2)' do
     exp = mtp(mtp(3,pow('y',3),'z'),mtp(pow(2,2),pow('y',-2)))
     result = exp.simplify_product_of_m_forms
    #  puts write_test(result)
     expect(result).to eq [
       '(3y^3z)(2^2y^{-2})'.objectify,
       '12yz'.objectify
     ]
    end

    it 'simplifies (2x^2yz)(3x^-2z^-1)' do
     exp = mtp(mtp(2,pow('x',2),'y','z'),mtp(3,pow('x',-2),pow('z',-1)))
     result = exp.simplify_product_of_m_forms
    #  puts write_test(result)
     expect(result).to eq [
       '(2x^2yz)(3x^{-2}z^{-1})'.objectify,
       '6y'.objectify
     ]
    end

    it 'simplifies x^2 3x' do
     exp = mtp(pow('x',2),3,'x')
     result = exp.simplify_product_of_m_forms
     expect(result).to eq [
       'x^23x'.objectify,
       '3x^3'.objectify
     ]
    end
  end

  describe '#standardize m form' do
    it 'turns m(x,m(xy)) to m(m(x)m(xy))' do
      exp = mtp('x',mtp('x','y'))
      result = exp.standardise_m_form
      expect(result).to eq mtp(mtp('x'),mtp('x','y'))
    end

    it 'turns m(x^2,y^3,m(x^2y))' do
      exp = mtp(pow('x',2),pow('y',3),mtp(pow('x',2),'y'))
      result = exp.standardise_m_form
      expect(result).to eq mtp(mtp(pow('x',2)),mtp(pow('y',3)),mtp(pow('x',2),'y'))
    end
  end

  describe '#combine_two_brackets' do
    it 'combines 2(x+3)' do
      exp = '2(x+3)'.objectify
      result = exp.combine_two_brackets
      # puts write_test(result)
      expect(result).to eq [
        '2(x+3)'.objectify,
        '2x+6'.objectify
      ]
    end

    it 'combines (2x+3)(4x+5)' do
      exp = '(2x+3)(4x+5)'.objectify
      result = exp.combine_two_brackets
      #  puts write_test(result)
      expect(result).to eq [
       '(2x+3)(4x+5)'.objectify,
       '2x(4x+5)+3(4x+5)'.objectify,
       '8x^2+10x+12x+15'.objectify,
       '8x^2+22x+15'.objectify
      ]
    end

    it 'combines (3+2x)(4x+5)' do
      exp = '(3+2x)(4x+5)'.objectify
      result = exp.combine_two_brackets
      #  puts write_test(result)

      expect(result).to eq [
       '(3+2x)(4x+5)'.objectify,
       '3(4x+5)+2x(4x+5)'.objectify,
       '12x+15+8x^2+10x'.objectify,
       '12x+10x+15+8x^2'.objectify,
       '22x+15+8x^2'.objectify
      ]
    end

    it 'combines (3x+2y+x^2)(x-x^2+3y)' do
      exp = '(3x+2y+x^2)(x-x^2+3y)'.objectify
      result = exp.combine_two_brackets
      expect(result).to eq [
       '(3x+2y+x^2)(x-x^2+3y)'.objectify,
       '3x(x-x^2+3y)+2y(x-x^2+3y)+x^2(x-x^2+3y)'.objectify,
       '3x^2-3x^3+9xy+2yx-2yx^2+6y^2+x^3-x^4+3x^2y'.objectify,
       '3x^2-3x^3+x^3+9xy+2yx-2yx^2+3x^2y+6y^2-x^4'.objectify,
       '3x^2-2x^3+11xy+yx^2+6y^2-x^4'.objectify
      ]
    end

    it 'combines 2x' do
      exp = mtp(2,'x')
      result = exp.combine_two_brackets
      # puts write_test(result)
      expect(result).to eq [
        '2x'.objectify
      ]
    end

    it 'combines 3x(x+4)' do
      exp = mtp(mtp(3,'x'),add('x',4))
      result = exp.combine_two_brackets
      # puts write_test(result)
      expect(result).to eq [
        '3x(x+4)'.objectify,
        '3x^2+12x'.objectify
      ]
    end

    it 'combines (2x)y' do
      exp = mtp(mtp(2,'x'),'y')
      result = exp.combine_two_brackets
      # puts write_test(result)
      expect(result).to eq [
        '2xy'.objectify
      ]
    end

    it 'combines y(2x)' do
      exp = mtp('y',mtp(2,'x'))
      result = exp.combine_two_brackets
      # puts write_test(result)
      expect(result).to eq [
        'y2x'.objectify,
        '2yx'.objectify
      ]
    end

    it 'combines (3yz)(2x)' do
      exp = mtp(mtp(3,'y','z'),mtp(2,'x'))
      result = exp.combine_two_brackets
      # puts write_test(result)
      expect(result).to eq [
        '3yz2x'.objectify,
        '6yzx'.objectify
      ]
    end

    # it 'combines (x-5)(2x)' do
    #   exp = mtp(add('x',-5),mtp(2,'x'))
    #   result = exp.combine_two_brackets
    #   expect(result).to eq [
    #     '(x-5)(2x)'.objectify,
    #     'x2x-5\times2x'.objectify,   #bug with simplify_product_of_m_forms  ******************
    #     '2x^2-10x'.objectify
    #   ]
    # end
  end

  describe '#expand' do

    # it 'expands (x^2-2x+7)(x^2+x-5)(x+3)' do
    #   exp = '(x^2-2x+7)(x^2+x-5)(x+3)'.objectify
    #   result = exp.expand
    #   puts write_test(result)
    # end

    xit 'expands (x+7)(x^2-5)(x+3)(2-x)' do
      exp = '(x+7)(x^2-5)(x+3)(2-x)'.objectify
      result = exp.expand
      puts write_test(result)
    end

    # it 'expands 2(x+4)' do
    #   exp = '2(x+4)'.objectify
    #   result = exp.expand
    #   puts write_test(result)
    # end
    #
    # it 'expands 2xy' do
    #   exp = '2xy'.objectify
    #   result = exp.expand
    #   puts write_test(result)
    # end

    xit 'expands 3xyzw(x+1)' do
      exp = '3xyzw(x+1)'.objectify
      result = exp.expand
      puts write_test(result)
    end

    it 'expands 3x(x+2)x^2(x-4)' do
      exp = '(2x)(x+2)yzw(x-4)'.objectify
      result = exp.expand
      puts write_test(result)
    end
  end


 #   xdescribe '#combine n brackets' do
 #
 #     it 'combines (x+y)(x+y)(x+y)' do
 #       exp = mtp(add('x','y'),add('x','y'),add('x','y'))
 #       result = exp.combine_brackets
 #      #  expect(result.last).to eq 'x^3+3x^2y+3xy^2+y^3'.objectify
 #
 #      # result.each_with_index do |a,i|
 #      #   string = "expect(result[" + i.to_s + "]).to eq '" + a.latex.shorten + "'.objectify"
 #      #   puts string
 #      # end
 #
 #      expect(result[0]).to eq '(x+y)(x+y)(x+y)'.objectify
 #      expect(result[1]).to eq '(xx+xy+yx+yy)(x+y)'.objectify
 #      expect(result[2]).to eq '(x^1x^1+xy+yx+y^1y^1)(x+y)'.objectify
 #      expect(result[3]).to eq '(x^{1+1}+xy+yx+y^{1+1})(x+y)'.objectify
 #      expect(result[4]).to eq '(x^2+xy+yx+y^2)(x+y)'.objectify
 #      expect(result[5]).to eq '(x^2+xy+xy+y^2)(x+y)'.objectify
 #      expect(result[6]).to eq '(x^2+2xy+y^2)(x+y)'.objectify
 #      expect(result[7]).to eq 'x^2x+x^2y+2xyx+2xyy+y^2x+y^2y'.objectify
 #      expect(result[8]).to eq 'x^2x+x^2y+2xxy+2xyy+y^2x+y^2y'.objectify
 #      expect(result[9]).to eq 'x^2x^1+x^2y+2x^1x^1y+2xy^1y^1+y^2x+y^2y^1'.objectify
 #      expect(result[10]).to eq 'x^{2+1}+x^2y+2x^{1+1}y+2xy^{1+1}+y^2x+y^{2+1}'.objectify
 #      expect(result[11]).to eq 'x^3+x^2y+2x^2y+2xy^2+y^2x+y^3'.objectify
 #      expect(result[12]).to eq 'x^3+x^2y+2x^2y+2xy^2+xy^2+y^3'.objectify
 #
 #
 #
 #     end
 #
 #
 #     it 'combines (x+y)(x+z)(y+z)' do
 #       exp = mtp(add('x','y'),add('x','z'),add('y','z'))
 #       result = exp.combine_brackets
 #
 #
 #        expect(result[0]).to eq '(x+y)(x+z)(y+z)'.objectify
 #        expect(result[1]).to eq '(xx+xz+yx+yz)(y+z)'.objectify
 #        expect(result[2]).to eq '(x^1x^1+xz+yx+yz)(y+z)'.objectify
 #        expect(result[3]).to eq '(x^{1+1}+xz+yx+yz)(y+z)'.objectify
 #        expect(result[4]).to eq '(x^2+xz+yx+yz)(y+z)'.objectify
 #        expect(result[5]).to eq '(x^2+xz+xy+yz)(y+z)'.objectify
 #        expect(result[6]).to eq '(x^2+xy+xz+yz)(y+z)'.objectify
 #        expect(result[7]).to eq 'x^2y+x^2z+xyy+xyz+xzy+xzz+yzy+yzz'.objectify
 #        expect(result[8]).to eq 'x^2y+x^2z+xyy+xyz+xzy+xzz+yyz+yzz'.objectify
 #        expect(result[9]).to eq 'x^2y+x^2z+xy^1y^1+xyz+xzy+xz^1z^1+y^1y^1z+yz^1z^1'.objectify
 #        expect(result[10]).to eq 'x^2y+x^2z+xy^{1+1}+xyz+xzy+xz^{1+1}+y^{1+1}z+yz^{1+1}'.objectify
 #        expect(result[11]).to eq 'x^2y+x^2z+xy^2+xyz+xzy+xz^2+y^2z+yz^2'.objectify
 #        expect(result[12]).to eq 'x^2y+x^2z+xy^2+xyz+xyz+xz^2+y^2z+yz^2'.objectify
 #
 #     end
 #
 #     xit 'combines (x+y)(x+y)(x+y)(x+y)' do
 #       exp = mtp(add('x','y'),add('x','y'),add('x','y'),add('x','y'))
 #       result = exp.combine_brackets
 #
 #        expect(result[0]).to eq '(x+y)(x+y)(x+y)(x+y)'.objectify
 #        expect(result[1]).to eq '(xx+xy+yx+yy)(x+y)(x+y)'.objectify
 #        expect(result[2]).to eq '(x^1x^1+xy+yx+y^1y^1)(x+y)(x+y)'.objectify
 #        expect(result[3]).to eq '(x^{1+1}+xy+yx+y^{1+1})(x+y)(x+y)'.objectify
 #        expect(result[4]).to eq '(x^2+xy+yx+y^2)(x+y)(x+y)'.objectify
 #        expect(result[5]).to eq '(x^2+xy+xy+y^2)(x+y)(x+y)'.objectify
 #        expect(result[6]).to eq '(x^2+2xy+y^2)(x+y)(x+y)'.objectify
 #        expect(result[7]).to eq '(x^2x+x^2y+2xyx+2xyy+y^2x+y^2y)(x+y)'.objectify
 #        expect(result[8]).to eq '(x^2x+x^2y+2xxy+2xyy+y^2x+y^2y)(x+y)'.objectify
 #        expect(result[9]).to eq '(x^2x^1+x^2y+2x^1x^1y+2xy^1y^1+y^2x+y^2y^1)(x+y)'.objectify
 #        expect(result[10]).to eq '(x^{2+1}+x^2y+2x^{1+1}y+2xy^{1+1}+y^2x+y^{2+1})(x+y)'.objectify
 #        expect(result[11]).to eq '(x^3+x^2y+2x^2y+2xy^2+y^2x+y^3)(x+y)'.objectify
 #        expect(result[12]).to eq '(x^3+x^2y+2x^2y+2xy^2+xy^2+y^3)(x+y)'.objectify
 #        expect(result[13]).to eq '(x^3+3x^2y+3xy^2+y^3)(x+y)'.objectify
 #        expect(result[14]).to eq 'x^3x+x^3y+3x^2yx+3x^2yy+3xy^2x+3xy^2y+y^3x+y^3y'.objectify
 #        expect(result[15]).to eq 'x^3x+x^3y+3x^2xy+3x^2yy+3xxy^2+3xy^2y+y^3x+y^3y'.objectify
 #        expect(result[16]).to eq 'x^3x^1+x^3y+3x^2x^1y+3x^2y^1y^1+3x^1x^1y^2+3xy^2y^1+y^3x+y^3y^1'.objectify
 #        expect(result[17]).to eq 'x^{3+1}+x^3y+3x^{2+1}y+3x^2y^{1+1}+3x^{1+1}y^2+3xy^{2+1}+y^3x+y^{3+1}'.objectify
 #        expect(result[18]).to eq 'x^4+x^3y+3x^3y+3x^2y^2+3x^2y^2+3xy^3+y^3x+y^4'.objectify
 #        expect(result[19]).to eq 'x^4+x^3y+3x^3y+3x^2y^2+3x^2y^2+3xy^3+xy^3+y^4'.objectify
 #     end
 #
 #     it 'combines x(y+z)' do
 #       exp = mtp('x',add('y','z'))
 #       result = exp.combine_brackets
 #       expect(result[0]).to eq mtp(add('x'),add('y','z'))
 #       expect(result[1]).to eq add(mtp(mtp('x'),mtp('y')),mtp(mtp('x'),mtp('z')))
 #       expect(result[2]).to eq add(mtp('x','y'),mtp('x','z'))
 #     end
 #
 #   xit 'combines (3x^2y^3+4x^3y^5)(5xy^4+6x^3y^-2)'do
 #    exp = '(3x^2y^3+4x^3y^5)(5xy^4+6x^3y^{-2})'.objectify
 #    result = exp.combine_brackets
 #
 #    result.each_with_index do |a,i|
 #      string = "expect(result[" + i.to_s + "]).to eq '" + a.latex.shorten + "'.objectify"
 #      puts string
 #    end
 #    expect(result[0]).to eq '(3x^2y^3+4x^3y^5)(5xy^4+6x^3y^{-2})'.objectify
 #    # expect(result[1]).to eq '(3x^2y^3)(5xy^4)+(3x^2y^3)(6x^3y^{-2})+(4x^3y^5)(5xy^4)+(4x^3y^5)(6x^3y^{-2})'.objectify
 #    expect(result[1]).to eq '(3x^2y^3)(5xy^4)+(3x^2y^3)(6x^3y^{-2})'.objectify
 #
 #    # expect(result[2]).to eq '(3\times5)(x^2x)(y^3y^4)+(3\times6)(x^2x^3)(y^3y^-2)+(4\times5)(x^3x)(y^5y^4)+(4\times6)(x^3x^3)(y^5y^-2)'.objectify
 #    # expect(result[3]).to eq '15(x^2x^1)y^{3+4}+18x^{2+3}y^{3+-2}+20(x^3x^1)y^{5+4}+24x^{3+3}y^{5+-2}'.objectify
 #    # expect(result[4]).to eq '15x^{2+1}y^7+18x^5y^1+20x^{3+1}y^9+24x^6y^3'.objectify
 #    # expect(result[5]).to eq '15x^3y^7+18x^5y+20x^4y^9+24x^6y^3'.objectify
 #    # expect(result[6]).to eq '24x^6y^3+18x^5y+20x^4y^9+15x^3y^7'.objectify
 #    # expect(result[6]).to eq '24x^6y^3+18x^5y+20x^4y^9+15x^3y^7'.objectify
 #
 #   end
 #
 #
 #  end
 #
 #  describe '#delete nils' do
 #    it 'deletes nils' do
 #      exp = mtp(5, nil, 'y')
 #      result = exp.delete_nils
 #      expect(exp).to eq mtp(5, 'y')
 #    end
 #  end
 #
 #  describe '#collect_same_base' do
 #    it 'collects powers of the same base while deleting them from self' do
 #      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
 #      result = exp.collect_next_variables
 #      expect(exp).to eq mtp(mtp(pow('y',3)),mtp(pow('y',5)))
 #      expect(result).to eq [pow('x',2),pow('x',4)]
 #    end
 #  end
 #
 #  describe '#fetch' do
 #    it 'retuns first object that matches class name String' do
 #      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
 #      expect(exp.fetch(object: :string)).to eq 'x'
 #    end
 #
 #    it 'retuns first object that matches class name Numeric' do
 #      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
 #      expect(exp.fetch(object: :numeric)).to eq 2
 #    end
 #  end
 #
 #  describe '#includes?' do
 #    it 'checks if mtp args contain String true' do
 #      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
 #      expect(exp.includes?(String)).to be true
 #    end
 #
 #    it 'checks if String exists in arguments false' do
 #      exp = mtp(mtp(pow(3,3)),mtp(pow(4,4),pow(5,5)))
 #      expect(exp.includes?(String)).to be false
 #    end
 #
 #    it 'checks if Numeric exists in arguments true' do
 #      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
 #      expect(exp.includes?(Numeric)).to be true
 #    end
 #
 #    it 'checks if Numeric exists in arguments false' do
 #      exp = mtp(mtp(pow('x','x'),pow('y','x')),mtp(pow('x','x'),pow('y','x')))
 #      expect(exp.includes?(Numeric)).to be false
 #    end
 #  end
 #
 #  describe '#m_form_sort' do
 #
 #    it 'swaps 3axba' do
 #      exp = mtp(3,'a','x','b','a')
 #      result = exp.m_form_sort
 #      expect(exp).to eq mtp(3,'a','a','b','x')
 #    end
 #
 #    it 'swaps 3x5a^2bx' do
 #      exp = mtp(3,'x',5,pow('a',2),'b','x')
 #      result = exp.m_form_sort
 #      expect(exp).to eq mtp(3,5,pow('a',2),'b','x','x')
 #    end
 #  end
 #
 #  describe '#similar?' do
 #    it 'comapres 3ayb^2a, 5ayb^2a, 5aybba' do
 #      m1 = mtp(4,'a','y',pow('b',2),'a')
 #      m2 = mtp(5,'a','y',pow('b',2),'a')
 #      m3 = mtp(5,'a','y','b','b','a')
 #      expect(m1.similar?(m2)).to eq true
 #      expect(m1.similar?(m3)).to eq false
 #      expect(m2.similar?(m3)).to eq false
 #    end
 #  end
 #

 #
 #  describe '#flatit' do
 #    it 'flats x(xy)(x(y(z)))' do
 #      exp = mtp('x',mtp('x','y'),mtp('x',mtp('y',mtp('z'))))
 #      result = exp.flatit
 #      expect(result).to eq mtp('x','x','y','x','y','z')
 #    end
 #
 #    it 'flats (xx) + xy' do
 #      exp = add(mtp(mtp('x','x')),mtp('x','y'))
 #      result = exp.flatit
 #      expect(result).to eq add(mtp('x','x'),mtp('x','y'))
 #    end
 #
 #    it 'flats (x^2)+y' do
 #      exp = add(mtp(pow('x',2)),'y')
 #      result = exp.flatit
 #      expect(result).to eq add(pow('x',2),'y')
 #    end
 #  end
 #
 #  describe '#top_heavy' do
 #    it 'top heavies 5xy(3/x+1)' do
 #      exp = mtp(5,'x','y',frac(3,add('x',1)))
 #      result = exp.top_heavy
 #      expect(result).to eq frac(mtp(5,'x','y',3),add('x',1))
 #    end
 #  end
 #
 #  describe '#top_heavy_div' do
 #    it 'top heavies 2((14-4y)/5)' do
 #      exp = mtp(2,div(add(14,mtp(-4,'y')),5))
 #      result = exp.top_heavy_div
 #      expect(result).to eq div(mtp(2,add(14,mtp(-4,'y'))),5)
 #    end
 #  end

end
