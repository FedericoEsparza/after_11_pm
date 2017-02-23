require './models/expression'
require './models/power'
require './models/addition'

# require './models/variables'
# require './models/numerals'
# require './models/factory'
# require './models/multiplication'

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


  describe '#simplify_add_m_forms' do

    it '#simplifies 3xy+2xy+xyz'do
    addition = add(mtp(3,'x','y'),mtp(2,'x','y'),mtp('x','y','z'))
    result = addition.simplify_add_m_forms
    expect(result).to eq add(mtp('x','y','z'),mtp('x','y',5))
    end
    #
    it '#simplifies 3xy+yx+x^2' do
    addition = add(mtp(3,'x','y'),mtp('y','x'),mtp(pow('x',2)))
    result = addition.simplify_add_m_forms
    expect(result).to eq add(mtp(pow('x',2)),mtp('x','y',4))
    end

    it '#simplifies x^2 + xy + yx + y^2' do
    addition = add(mtp(pow('x',2)),mtp('x','y'),mtp('y','x'),mtp(pow('y',2)))
    result = addition.simplify_add_m_forms
    expect(result).to eq add(mtp(pow('x',2)),mtp('x','y',2),mtp(pow('y',2)))
    end

    it '#simplifies x^2 + x^2 + y^2' do
      addition = add(mtp(pow('x',2)),mtp(pow('x',2)),mtp(pow('y',2)))
      result = addition.simplify_add_m_forms
      expect(result).to eq add(mtp(pow('x',2),2),mtp(pow('y',2)))
    end
  end

end
