require './models/multiplication'
require './models/power'
require './models/addition'
require './models/variables'
require './models/numerals'
require './models/factory'

include Factory

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
      # expect(exp).to eq mtp(4,mtp(pow('x',2),'x'),'y')
      # expect(result).to eq [
      #   mtp(pow('x',2),mtp(4,'x','y')),
      #   mtp(4,mtp(pow('x',2),'x'),'y')
      # ]
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


    it 'simplifies (3y^3z)(2^2y^-2) to 12yz' do
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

    it 'simplifies x3(2x^2) to 6x^3' do
      exp = mtp('x', 3, mtp(2,pow('x',2)))
      result = exp.simplify_product_of_m_forms
      expect(exp).to eq mtp(6,pow('x', 3))
      expect(result).to eq [
        mtp(mtp('x', 3, mtp(2,pow('x',2)))),
        mtp(mtp(3,2),mtp(pow('x',1),pow('x',2))),
        mtp(mtp(6 ,pow('x',add(1,2)))),
        mtp(6,pow('x', 3))
      ]
    end

  end

  context '#standardize_args' do
    it "converts strings and integers to variables and numerals respectively" do
      exp = mtp('x', 3, mtp(2, pow('x', 2)))
      response = [var('x'), num(3), mtp(num(2), pow(var('x'), num(2)))]
      result = exp.standardize_args
      expect(result).to match_array response
    end
  end


  #
  # describe '#collect_same_base' do
  #   it 'collects powers of the same base while deleting them from self' do
  #     exp = mtp(mtp(pow('x',2),pow('y',3)),mtp(pow('x',4),pow('y',5)))
  #     result = exp.collect_same_base('x')
  #     expect(exp).to eq mtp(mtp(pow('y',3)),mtp(pow('y',5)))
  #     expect(result).to eq [pow('x',2),pow('x',4)]
  #   end
  # end

end
