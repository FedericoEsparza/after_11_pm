require './helpers/objectify'

describe Objectify do
  let(:dummy_class){(Class.new{include Objectify}).new}

  describe '#objectify' do
    it 'x+2' do
      expect(dummy_class.objectify('x+2')).to eq add('x',2)
    end

    it 'x+y+2' do
      expect(dummy_class.objectify('x+y+2')).to eq add('x','y',2)
    end

    it '2x' do
      expect(dummy_class.objectify('2x')).to eq mtp(2,'x')
    end

    it '3xyz' do
      expect(dummy_class.objectify('3xyz')).to eq mtp(3,'x','y','z')
    end

    it '3x+5' do
      expect(dummy_class.objectify('3x+5')).to eq add(mtp(3,'x'),5)
    end

    it '\frac{3}{x}' do
      expect(dummy_class.objectify('\frac{3}{x}')).to eq div(3,'x')
    end

    it '\frac{3x+5}{4+5+a}' do
      expect(dummy_class.objectify('\frac{3x+5}{4+5+a}')).to eq div(add(mtp(3,'x'),5),add(4,5,'a'))
    end
  end

  describe '#matching_brackets' do
    it 'matches outer brackets in \frac{frac{2}{y}}{x}' do
      expect(dummy_class.matching_brackets('\frac{frac{2}{y}}{x}','{','}')).to eq [5,16]
    end

    it 'matches 3rd brackets in (a+c(234)de((abc))))' do
      expect(dummy_class.matching_brackets('(a+c(234)de((abc))))','(',')', 3)).to eq [11,17]
    end

    it 'matches 2nd brackets in a+c(234)de((abc)))' do
      expect(dummy_class.matching_brackets('a+c(234)de((abc))','(',')', 2)).to eq [10,16]
    end

  end

  describe '#empty_brackets' do
    it 'replace bracket (a+c(234)de((abc))) content with $ to ($$$$$$$$$$$$$$$$$)' do
      expect(dummy_class.empty_brackets(string: '(a+c(234)de((abc)))')).to eq '($$$$$$$$$$$$$$$$$)'
    end

    it 'replace bracket a+c(234)de((abc)) content with $ to a+c($$$)de($$$$$)' do
      expect(dummy_class.empty_brackets(string: 'a+c(234)de((abc))')).to eq 'a+c($$$)de($$$$$)'
    end

    it 'replace bracket \frac((3(x))^(()4y))(x^2)(234)de((abc)) content with $ to \frac($$$$$$$$$$$$$)($$$)($$$)de($$$$$)' do
      expect(dummy_class.empty_brackets(string: '\frac((3(x))^(()4y))(x^2)(234)de((abc))')).to eq '\frac($$$$$$$$$$$$$)($$$)($$$)de($$$$$)'
    end
  end

  describe '#split_mtp_args' do
    it 'extract args from ($$) return ["$$"]' do
      expect(dummy_class.split_mtp_args(string: '($$)')).to eq ["($$)"]
    end
    it 'extract args from 2x\frac($$$)($)($$$$)($$$)^($$)($$)^4 return ["$$"]' do
      expect(dummy_class.split_mtp_args(string: '2x\frac($$$)($)($$$$)($$$)^($$)($$)^4')).to eq ["2", "x", "\\frac($$$)($)", "($$$$)", "($$$)^($$)($$)^", "4"]
    end
  end
end
