require './models/expression'
require './models/power'
require './models/addition'
require './models/variables'
require './models/numerals'
require './models/factory'

require './models/multiplication'

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

  describe '#>' do
    it 'checks y > z' do
      mtp_1 = 'y'
      mtp_2 = 'z'
      result = mtp_1 > mtp_2
      expect(result).to eq true
    end

    it 'checks x^2(y+x) > x^2(y+x^2)' do
      mtp_1 = mtp(pow('x',2),add('y','x'))
      mtp_2 = mtp(pow('x',2),add('y',pow('x',2)))
      result = mtp_1 > mtp_2
      expect(result).to eq false
    end

    it 'checks x^3(y+x) > x^2(y+x^2)' do
      mtp_1 = mtp(pow('x',3),add('y','x'))
      mtp_2 = mtp(pow('x',2),add('y',pow('x',2)))
      result = mtp_1 > mtp_2
      expect(result).to eq true
    end

    it 'checks 4x > 4y' do
      mtp_1 = mtp(4,'x')
      mtp_2 = mtp(4,'y')
      result = mtp_1 > mtp_2
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

  describe '#combine_powers' do
    it 'combines x^2 times x^3' do
      exp = mtp(pow('x',2),pow('x',3))
      expect(exp.combine_powers).to eq [
        mtp(pow('x',2),pow('x',3)),
        pow('x',add(2,3)),
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
      mtp(pow('y',3),pow('y',-2)),
      pow('y',add(3,-2)),
      pow('y',1),
      'y'
      ]
    end


    it 'combines x times x^2' do
      exp = mtp('x',pow('x',2))
      expect(exp.combine_powers).to eq [
        mtp('x',pow('x',2)),
        mtp(pow('x',1),pow('x',2)),
        pow('x',add(1,2)),
        pow('x',3)
      ]
    end

    it 'combine y times y^3 times y^-2' do
      exp = mtp('y',pow('y',3),pow('y',-2))
      expect(exp.combine_powers).to eq [
        mtp('y',pow('y',3),pow('y',-2)),
        mtp(pow('y',1),pow('y',3),pow('y',-2)),
        pow('y',add(1,3,-2)),
        pow('y',2)
      ]
    end

    it 'combines 3 times 4 times 5' do
      exp = mtp(3,4,5)
      expect(exp.combine_powers).to eq [
        mtp(3,4,5),
        60
      ]
    end

    it 'combines 3 times 2^2 times 5' do
      exp = mtp(3,pow(2,2),5)
      expect(exp.combine_powers).to eq [
        mtp(3,pow(2,2),5),
        mtp(3,4,5),
        60
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
       expect(result).to eq [
         mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5))),
         mtp(mtp(pow('x',2),pow('x',4)),mtp(pow('y',3),pow('y',5)))
       ]
     end

     it 'separates (3x^2)(4xy^2) as (3 4)(x^2x)(y^2)' do
       exp = mtp(mtp(3,pow('x',2)),mtp(4,pow('x',3),pow('y',2)))
       result = exp.separate_variables
       expect(exp).to eq mtp(mtp(3,4),mtp(pow('x',2),pow('x',3)),mtp(pow('y',2)))
       expect(result).to eq [
         mtp(mtp(3,pow('x',2)),mtp(4,pow('x',3),pow('y',2))),
         mtp(mtp(3,4),mtp(pow('x',2),pow('x',3)),mtp(pow('y',2)))
       ]
     end

     it 'separates (3x^2)(4xy^2) as (3 4)(x^2x)(y^2)' do
       exp = mtp(mtp(3,pow('x',2)),mtp(4,'x',pow('y',2)))
       result = exp.separate_variables
       expect(exp).to eq mtp(mtp(3,4),mtp(pow('x',2),'x'),mtp(pow('y',2)))
       expect(result).to eq [
         mtp(mtp(3,pow('x',2)),mtp(4,'x',pow('y',2))),
         mtp(mtp(3,4),mtp(pow('x',2),'x'),mtp(pow('y',2)))
       ]
     end

     it 'separates (3x^2)(4xy^2) as (3 4)(x^2x)(y^2)' do
       exp = mtp(mtp(3,'x'),mtp(4,pow('x', 2),pow('y',2)))
       result = exp.separate_variables
       expect(exp).to eq mtp(mtp(3,4),mtp('x',pow('x', 2)),mtp(pow('y',2)))
       expect(result).to eq [
         mtp(mtp(3,'x'),mtp(4,pow('x', 2),pow('y',2))),
         mtp(mtp(3,4),mtp('x',pow('x', 2)),mtp(pow('y',2)))
       ]
     end
     it 'separates (3^2x^2)(4x) as (3^2 4)(x^2x)' do
       exp = mtp(mtp(pow(3,2),pow('x',2)),mtp(4,'x'))
       result = exp.separate_variables
       expect(exp).to eq mtp(mtp(pow(3,2),4),mtp(pow('x', 2),'x'))
       expect(result).to eq [
         mtp(mtp(pow(3,2),pow('x',2)),mtp(4,'x')),
         mtp(mtp(pow(3,2),4),mtp(pow('x', 2),'x'))
       ]
     end

     it 'separates (x^2)(4xy) as (4)(x^2x)(y)' do
       exp = mtp(mtp(pow('x',2)),mtp('x','y'))
       result = exp.separate_variables
      #  expect(exp).to eq mtp(4,mtp(pow('x',2),'x'),'y')
      #  expect(result).to eq [
      #    mtp(pow('x',2),mtp(4,'x','y')),
      #    mtp(4,mtp(pow('x',2),'x'),'y')
      #  ]
     end

     it 'separates (x^2)(3x)(4xy)' do
       exp = mtp(mtp(pow('x',2)),mtp(3,'x'),mtp(4,'x','y'))
       result = exp.separate_variables
       expect(exp).to eq mtp(mtp(pow('x',2),'x','x'),mtp(3,4),mtp('y'))
     end

   end

   describe '#eval_numerics' do
     it 'evaluates to a product of the arguments' do
       multiplication = mtp(1,-2,3)
       expect(multiplication.eval_numerics).to eq -6
     end
   end


   describe '#simplify_product_of_m_forms' do
     it 'simplifies (3x^2y3)(3xy^4) to 9x^3y^7' do
       exp = mtp(mtp(3,pow('x',2),pow('y',3)),mtp(3,'x',pow('y',4)))
       result = exp.simplify_product_of_m_forms
       expect(exp).to eq mtp(9,pow('x',3),pow('y',7))
       expect(result).to eq [
         mtp(mtp(3,pow('x',2),pow('y',3)),mtp(3,'x',pow('y',4))),
         mtp(mtp(3,3),mtp(pow('x',2),'x'),mtp(pow('y',3),pow('y',4))),
         mtp(9,mtp(pow('x',2),pow('x',1)),pow('y',add(3,4))),
         mtp(9,pow('x',add(2,1)),pow('y',7)),
         mtp(9,pow('x',3),pow('y',7))
       ]
     end
       it 'simplifies (3x)(4y)(5z) to 60xyz' do
         exp = mtp(mtp(3,'x'),mtp(4,'y'),mtp(5,'z'))
         result = exp.simplify_product_of_m_forms
         expect(exp).to eq mtp(60,'x','y','z')
       expect(result).to eq [
         mtp(mtp(3,'x'),mtp(4,'y'),mtp(5,'z')),
         mtp(mtp(3,4,5),'x','y','z'),
         mtp(60,'x','y','z')
       ]
     end


     it 'simplifies (3y^3z)(2^2y^-2)' do
       exp = mtp(mtp(3,pow('y',3),'z'),mtp(pow(2,2),pow('y',-2)))
       result = exp.simplify_product_of_m_forms
       expect(exp).to eq mtp(12,'y','z')
       expect(result).to eq [
         mtp(mtp(3,pow('y',3),'z'),mtp(pow(2,2),pow('y',-2))),
         mtp(mtp(3,pow(2,2)),mtp(pow('y',3),pow('y',-2)),'z'),
         mtp(mtp(3,4),pow('y',add(3,-2)),'z'),
         mtp(12,pow('y',1),'z'),
         mtp(12,'y','z')
       ]
     end

     it 'simplifies (2x^2yz)(3x^-2z^-1)' do
       exp = mtp(mtp(2,pow('x',2),'y','z'),mtp(3,pow('x',-2),pow('z',-1)))
       result = exp.simplify_product_of_m_forms
       expect(exp).to eq mtp(6,'y')
       expect(result).to eq [
         mtp(mtp(2,pow('x',2),'y','z'),mtp(3,pow('x',-2),pow('z',-1))),
         mtp(mtp(2,3),mtp(pow('x',2),pow('x',-2)),'y',mtp('z',pow('z',-1))),
         mtp(6,pow('x',add(2,-2)),'y',mtp(pow('z',1),pow('z',-1))),
         mtp(6,pow('x',0),'y',pow('z',add(1,-1))),
         mtp(6,'y',pow('z',0)),
         mtp(6,'y')
       ]
     end
   end

   describe '#standardize m form' do
     it 'turns m(x,m(xy)) to m(m(x)m(xy))' do
       exp = mtp('x',mtp('x','y'))
       result = exp.standardize_m_form
       expect(result).to eq mtp(mtp('x'),mtp('x','y'))
     end

     it 'turns m(x^2,y^3,m(x^2y))' do
       exp = mtp(pow('x',2),pow('y',3),mtp(pow('x',2),'y'))
       result = exp.standardize_m_form
        expect(result).to eq mtp(mtp(pow('x',2)),mtp(pow('y',3)),mtp(pow('x',2),'y'))
     end

   end


   describe '#combine_two_brackets' do

     it 'combines (x+y)(x+y)' do
       exp = mtp(add('x','y'),add('x','y'))
       result = exp.combine_two_brackets
       expect(exp.args).to eq [mtp(pow('x',2)),mtp(2,'x','y'),mtp(pow('y',2))]
       expect(result).to eq [
         mtp(add('x','y'),add('x','y')),
         add(mtp('x','x'),mtp('x','y'),mtp('y','x'),mtp('y','y'))
         add()
       ]
     end

     it 'combines (3x^2y^3-4x^3y^5)(5xy^4+6x^3y^-2)'do
      exp = mtp(add(mtp(3,pow('x',2),pow('y',3)),mtp(-4,pow('x',3),pow('y',5))),add(mtp(5,'x',pow('y',4)),mtp(6,pow('x',3),pow('y',-2))))
      result = exp.combine_two_brackets
      expect(exp.args).to eq [mtp(-24,pow('x',6),pow('y',3)),mtp(18,pow('x',5),'y'),mtp(-20,pow('x',4),pow('y',9)),mtp(15,pow('x',3),pow('y',7))]
     end

     it 'combines (x^2 + 2xy + y^2)(x+y)' do
       exp = mtp(add(pow('x',2),mtp(2,'x','y'),pow('y',2)),add('x','y'))
       result = exp.combine_two_brackets
       expect(exp.args).to eq [mtp(pow('x',3)),mtp(3,pow('x',2),'y'),mtp(3,'x',pow('y',2)),mtp(pow('y',3))]
     end
   end

  describe '#delete nils' do
    it 'deletes nils' do
      exp = mtp(5, nil, 'y')
      result = exp.delete_nils
      expect(exp).to eq mtp(5, 'y')
    end
  end

  describe '#collect_same_base' do
    it 'collects powers of the same base while deleting them from self' do
      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
      result = exp.collect_next_variables
      expect(exp).to eq mtp(mtp(pow('y',3)),mtp(pow('y',5)))
      expect(result).to eq [pow('x',2),pow('x',4)]
    end
  end

  describe '#fetch' do
    it 'retuns first object that matches class name String' do
      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
      expect(exp.fetch(object: :string)).to eq 'x'
    end

    it 'retuns first object that matches class name Numeric' do
      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
      expect(exp.fetch(object: :numeric)).to eq 2
    end
  end

  describe '#includes?' do
    it 'checks if mtp args contain String true' do
      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
      expect(exp.includes?(String)).to be true
    end

    it 'checks if String exists in arguments false' do
      exp = mtp(mtp(pow(3,3)),mtp(pow(4,4),pow(5,5)))
      expect(exp.includes?(String)).to be false
    end

    it 'checks if Numeric exists in arguments true' do
      exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
      expect(exp.includes?(Numeric)).to be true
    end

    it 'checks if Numeric exists in arguments false' do
      exp = mtp(mtp(pow('x','x'),pow('y','x')),mtp(pow('x','x'),pow('y','x')))
      expect(exp.includes?(Numeric)).to be false
    end
  end
end
