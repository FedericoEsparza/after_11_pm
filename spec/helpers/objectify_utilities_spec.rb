require './helpers/objectify_utilities'

describe ObjectifyUtilities do
  let(:dummy_class){(Class.new{include ObjectifyUtilities}).new}

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

    it 'matches ($$$)^($$) 2nd brackets' do
      expect(dummy_class.matching_brackets('($$$)^($$)($$$)^4','(',')', 2)).to eq [6,9]
    end
  end

  describe '#empty_brackets' do
    it 'replace bracket (a+c{234}de((abc))) content with $ to ($$$$$$$$$$$$$$$$$)' do
      expect(dummy_class.empty_brackets('(a+c(234)de((abc)))')).to eq '($$$$$$$$$$$$$$$$$)'
    end

    it 'replace bracket a+c{234}de[{abc}] content with $ to a+c{$$$}de[$$$$$]' do
      expect(dummy_class.empty_brackets('a+c{234}de[{abc}]')).to eq 'a+c{$$$}de[$$$$$]'
    end

    it 'replace bracket \frac((3(x))^(()4y))(x^2)(234)de((abc)) content with $ to \frac($$$$$$$$$$$$$)($$$)($$$)de($$$$$)' do
      expect(dummy_class.empty_brackets('\frac{(3(x))^(()4y)}{x^2}(234)de((abc))')).to eq '\frac{$$$$$$$$$$$$$}{$$$}($$$)de($$$$$)'
    end
  end

  describe '#split_mtp_args' do
    it '' do
      str = '2\times3'
      expect(dummy_class.split_mtp_args(str)).to eq ["2","3"]
    end

    it '' do
      str = "x^{$$}"
      expect(dummy_class.split_mtp_args(str)).to eq ["x^{$$}"]
    end

    it '' do
      str = "-12x"
      expect(dummy_class.split_mtp_args(str)).to eq ["-12",'x']
    end

    it 'extract args from ($$) return ["$$"]' do
      expect(dummy_class.split_mtp_args('($$)')).to eq ["($$)"]
    end

    it '' do
      str = '2x\frac{$$$}{$}($$$$)($$$)^{$$}'
      expect(dummy_class.split_mtp_args(str)).to eq [
        "2", "x", "\\frac{$$$}{$}", "($$$$)", "($$$)^{$$}"
      ]
    end

    it '' do
      str = '($$$$)($$$)^{$$}($$$)^4'
      expect(dummy_class.split_mtp_args(str)).to eq [
        "($$$$)", "($$$)^{$$}", "($$$)^4"
      ]
    end

    it '' do
      str = '($$$$)($$$)^{$$}4^{$$$}5'
      expect(dummy_class.split_mtp_args(str)).to eq [
        "($$$$)", "($$$)^{$$}", "4^{$$$}",'5'
      ]
    end

    it '' do
      str = '($$$)^{$$}4^{$$$}5'
      expect(dummy_class.split_mtp_args(str)).to eq [
        '($$$)^{$$}',"4^{$$$}",'5'
      ]
    end

    it '' do
      str = '($$$$)($$$)^{$$}4x'
      expect(dummy_class.split_mtp_args(str)).to eq [
        "($$$$)", "($$$)^{$$}", "4",'x'
      ]
    end

    it '' do
      str = "($$$)^{$$$$}"
      expect(dummy_class.split_mtp_args(str)).to eq ["($$$)^{$$$$}"]
    end

    it '' do
      str = "3^4x"
      expect(dummy_class.split_mtp_args(str)).to eq ["3^4",'x']
    end

    it '' do
      str = "12^{$$$}"
      expect(dummy_class.split_mtp_args(str)).to eq ["12^{$$$}"]
    end

    it '' do
      str = "($$$$$)^{$$$}"
      expect(dummy_class.split_mtp_args(str)).to eq ["($$$$$)^{$$$}"]
    end

    it '' do
      str = "xy"
      expect(dummy_class.split_mtp_args(str)).to eq ['x','y']
    end

    it '' do
      str = "x12^{$$$}"
      expect(dummy_class.split_mtp_args(str)).to eq ['x','12^{$$$}']
    end

    it '' do
      str = '\frac{$$$}{$$$$$}xy'
      expect(dummy_class.split_mtp_args(str)).to eq ['\frac{$$$}{$$$$$}','x','y']
    end

    it '' do
      str = "123x"
      expect(dummy_class.split_mtp_args(str)).to eq ['123','x']
    end

    it '' do
      str = "-xy"
      expect(dummy_class.split_mtp_args(str)).to eq ['-','x','y']
    end

    it '' do
      str = "-12xy"
      expect(dummy_class.split_mtp_args(str)).to eq ['-12','x','y']
    end

    it '' do
      str = "-12^xy"
      expect(dummy_class.split_mtp_args(str)).to eq ['-','12^x','y']
    end

    it '' do
      str = '-\frac{$}{$}'
      expect(dummy_class.split_mtp_args(str)).to eq ['-','\frac{$}{$}']
    end
  end

  # describe '#reenter_str_content' do
  #   it '' do
  #     string = 'x(2-a)y3(5z)^4'
  #     dollar_array = ["x","($$$)",'y','3',"($$)^4"]
  #     dummy_class.reenter_str_content(string,dollar_array:dollar_array)
  #     expect(dollar_array).to eq ["x","(2-a)",'y','3',"(5z)^4"]
  #   end
  # end
  #
  # describe '#reenter_addition_str_content' do
  #   it '' do
  #     string = 'x+(2-a)+y+3+(5z)^4'
  #     dollar_array = ["x","($$$)",'y','3',"($$)^4"]
  #     dummy_class.reenter_addition_str_content(string:string,dollar_array:dollar_array)
  #     expect(dollar_array).to eq ["x","(2-a)",'y','3',"(5z)^4"]
  #   end
  # end
  #
  describe '#remove_enclosing_bracks' do
    it '' do
      string_array = ["(2-a)"]
      dummy_class.remove_enclosing_bracks(string_array)
      expect(string_array).to eq ["2-a"]
    end

    it '' do
      string_array = ["(2-a)(2-a)"]
      dummy_class.remove_enclosing_bracks(string_array)
      expect(string_array).to eq ["(2-a)(2-a)"]
    end

    it '' do
      string_array = ["x","(2-a)",'y','3',"(5z)^4"]
      dummy_class.remove_enclosing_bracks(string_array)
      expect(string_array).to eq ["x","2-a",'y','3',"(5z)^4"]
    end
  end
  #
  # describe '#_next_num_index' do
  #   it 'returns 2 for 123abc' do
  #     expect(dummy_class._next_num_index('123abc')).to eq 2
  #   end
  #
  #   it 'returns nil for 123^abc' do
  #     expect(dummy_class._next_num_index('123^abc')).to eq nil
  #   end
  #
  #   it 'returns nil for 123456' do
  #     expect(dummy_class._next_num_index('123456')).to eq 5
  #   end
  #
  #   it 'returns nil for ($$$$)123456' do
  #     expect(dummy_class._next_num_index('($$$$)123456')).to eq nil
  #   end
  # end
end
