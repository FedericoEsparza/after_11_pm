describe String do
  describe '#objectify' do
    it '-x' do
      expect('-x'.objectify).to eq mtp(-1,'x')
    end

    it '2\times3' do
      expect('2\times3'.objectify).to eq mtp(2,3)
    end

    it '2\times123' do
      expect('2\times123'.objectify).to eq mtp(2,123)
    end

    it '2\timesx' do
      expect('2\timesx'.objectify).to eq mtp(2,'x')
    end

    it '2\times(-23)' do
      expect('2\times(-23)'.objectify).to eq mtp(2,-23)
    end

    it '-2x--3' do
      expect('-2x--3'.objectify).to eq sbt(mtp(-2,'x'),-3)
    end

    it 'a-b' do
      expect('a-b'.objectify).to eq add('a',mtp(-1,'b'))
    end

    it '-2+a' do
      expect('-2+a'.objectify).to eq add(-2,'a')
    end

    it 'a+b-c' do
      expect('a+b-c'.objectify).to eq add('a','b',mtp(-1,'c'))
    end

    it 'a+b-c-d' do
      expect('a+b-c-d'.objectify).to eq add('a','b',mtp(-1,'c'),mtp(-1,'d'))
    end

    it 'a-b+c+d' do
      expect('a-b+c+d'.objectify).to eq add('a',mtp(-1,'b'),'c','d')
    end

    it 'c+d-e+f+g' do
      expect('c+d-e+f+g'.objectify).to eq add('c','d',mtp(-1,'e'),'f','g')
    end

    it 'z+a+b-c+d-e+f+g' do
      expect('z+a+b-c+d-e+f+g'.objectify).to eq add('z','a','b',mtp(-1,'c'),'d',mtp(-1,'e'),'f','g')
    end

    it 'x+-12' do
      expect('x+-12'.objectify).to eq add('x',-12)
    end

    it 'x+y+2' do
      expect('x+y+2'.objectify).to eq add('x','y',2)
    end

    it 'x+(y+2)' do
      expect('x+(y+2)'.objectify).to eq add('x',add('y',2))
    end

    it '-12x' do
      expect('-12x'.objectify).to eq mtp(-12,'x')
    end

    it '(-12)^{-31x}' do
      expect('(-12)^{-31x}'.objectify).to eq pow(-12,mtp(-31,'x'))
    end

    it '3xyz' do
      expect('3xyz'.objectify).to eq mtp(3,'x','y','z')
    end

    it '-3x+-5' do
      expect('-3x+-5'.objectify).to eq add(mtp(-3,'x'),-5)
    end

    it '-3x+-5' do
      expect('(-3)x+(-5)'.objectify).to eq add(mtp(-3,'x'),-5)
    end

    it '25+(-13)x' do
      expect('25+(-13)x'.objectify).to eq add(25,mtp(-13,'x'))
    end

    it '\frac{-14x}{25}' do
      expect('\frac{-14x}{25}'.objectify).to eq div(mtp(-14,'x'),25)
    end

    it '3(x+7)+4' do
      expect('3(x+7)+4'.objectify).to eq add(mtp(3,add('x',7)),4)
    end

    it '-13(x+7)(y+(5+(2a+9)))' do
      expect('-13(x+7)(y+5(-12a+9))'.objectify).to eq mtp(-13,add('x',7),add('y',mtp(5,add(mtp(-12,'a'),9))))
    end

    it '-13(x+7)(y+2)+4' do
      expect('13(x+7)+4'.objectify).to eq add(mtp(13,add('x',7)),4)
    end

    it '-13(x+7)+4' do
      expect('-13(x+7)+4'.objectify).to eq add(mtp(-13,add('x',7)),4)
    end

    it '-13(x+7)-4' do
      expect('-13(x+7)-4'.objectify).to eq add(mtp(-13,add('x',7)),-4)
    end
    it '\frac{3}{x}' do
      expect('\frac{3}{x}'.objectify).to eq div(3,'x')
    end

    it '\frac{3x+5}{4+5+a}' do
      expect('\frac{3x+5}{4+5+a}'.objectify).to eq div(add(mtp(3,'x'),5),add(4,5,'a'))
    end

    it '3(x+\frac{3x+5}{4+5+a})+4' do
      expect('3(x+\frac{3x+5}{4+5+a})+4'.objectify).to eq add(mtp(3,add('x',div(add(mtp(3,'x'),5),add(4,5,'a')))),4)
    end

    it '\frac{3x+5}{4+5+a}' do
      expect('\frac{3x+3xyz}{4+5+a}'.objectify).to eq div(add(mtp(3,'x'),mtp(3,'x','y','z')),add(4,5,'a'))
    end

    it '3(x+\frac{3\frac{3}{x}+5}{4+5+a})+4' do
      expect('3(x+\frac{3\frac{3}{x}+5}{4+5+a})+4'.objectify).to eq add(mtp(3,add('x',div(add(mtp(3,div(3,'x')),5),add(4,5,'a')))),4)
    end

    it 'objectifies -x+2' do
      str = '-x+2'
      expect(str.objectify).to eq add(mtp(-1,'x'),2)
    end

    it 'objectifies 2xy' do
      str = '2xy'
      expect(str.objectify).to eq mtp(2,'x','y')
    end

    it 'objectifies 3(x+\frac{3x+5}{4+5+a})+4' do
      str = '3(x+\frac{3x+5}{4+5+a})+4'
      expect(str.objectify).to eq add(mtp(3,add('x',div(add(mtp(3,'x'),5),add(4,5,'a')))),4)
    end

    it 'x^{ 3y}' do
      expect('x^{ 3y}'.objectify).to eq pow('x',mtp(3,'y'))
    end

    it '(2x)^13' do
      expect('(2x)^13)'.objectify).to eq mtp(pow(mtp(2,'x'),1),3)
    end

    it '(2xy)^{-3x-4}' do
      expect('(2xy)^{-3x-4}'.objectify).to eq pow(mtp(2,'x','y'),add(mtp(-3,'x'),-4))
    end

    it '(2^{3xy})^{5x+4}' do
      expect('(2^{3xy})^{5x+4}'.objectify).to eq pow(pow(2,mtp(3,'x','y')),add(mtp(5,'x'),4))
    end

    it '2^{3xy}' do
      expect('2^{3xy}'.objectify).to eq pow(2,mtp(3,'x','y'))
    end

    it 'x^{1+1}' do
      expect('x^{1+1}'.objectify).to eq pow('x',add(1,1))
    end

    it '\frac{c}{d}(2x+4^x)' do
      expect('\frac{c}{d}(2x+4^x)'.objectify).to eq mtp(div('c','d'),add(mtp(2,'x'),pow(4,'x')))
    end

    it '\frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}}' do
      exp = '\frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}}'
      expect(exp.objectify).to eq add(div('a','b'),pow(mtp(div('c','d'),add(mtp(2,'x'),pow(4,'x'))),div(5,'y')))
    end

    it '(3x^2y^3)(5xy^4)+(3x^2y^3)(6x^3y^{-2})' do
      str = '\frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}}'
      expect(str.objectify.latex.shorten).to eq str
    end

    it '(2x)^3' do
      expect('(2x)^3'.objectify).to eq pow(mtp(2,'x'),3)
    end

    it '-2-3' do
      expect('-2-3'.objectify).to eq add(-2,-3)
    end

    it '-2x-3' do
      expect('-2x-3'.objectify).to eq add(mtp(-2,'x'),-3)
    end

    it 'x^{1^1}' do
      expect('x^{1^1}'.objectify).to eq pow('x',pow(1,1))
    end

    it '-xy' do
      expect('-xy'.objectify).to eq mtp(-1,'x','y')
    end

    it '-12^y' do
      expect('-12^y'.objectify).to eq mtp(-1,pow(12,'y'))
    end

    it '-\frac{a}{12+x}' do
      expect('-\frac{a}{b}'.objectify).to eq mtp(-1,div('a','b'))
    end

    it 'x+-3' do
      expect('x-3'.objectify).to eq add('x',-3)
    end

    context 'equation' do
      it 'x+3=2' do
        expect('x+3=2'.objectify).to eq eqn(add('x',3),2)
      end

      it 'x-3=2' do
        expect('x-3=2'.objectify).to eq eqn(add('x',-3),2)
      end

      it '3x=2' do
        expect('3x=2'.objectify).to eq eqn(mtp(3,'x'),2)
      end
    end


  end

  xdescribe 'objectify and olatex back' do
    it 'objectify and olatex back 2^{3xy}' do
      expect(dummy_class.objectify('2^{3xy}').latex.shorten).to eq '2^{3xy}'
    end
  end

  xdescribe '#correct_latex?' do
    it 'is \frac{c}{d}(2x+4^x) correct_latex?' do
      expect('\frac{c}{d}(2x+4^x)'.correct_latex?).to be true
    end

    it 'is \frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}} correct_latex?' do
      expect('\frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}}'.correct_latex?).to be true
    end
  end

  describe '#_outer_func_is_add?' do
    it '3-x-4 to false' do
      expect('3-x-4'._outer_func_is_add?).to be false
    end

    it '3+x+4 to true' do
      expect('3+x+4'._outer_func_is_add?).to be true
    end

    it '3+x-4 to false' do
      expect('3+x-4'._outer_func_is_add?).to be false
    end

    it '3+x+-4 to true' do
      expect('3+x+-4'._outer_func_is_add?).to be true
    end

    it '-3+x+-4 to true' do
      expect('-3+x+-4'._outer_func_is_add?).to be true
    end
  end

  describe '#_outer_func_is_sbt?' do
    it '3-x-4 to true' do
      expect('3-x-4'._outer_func_is_sbt?).to be true
    end

    it '3+x+4 to false' do
      expect('3+x+4'._outer_func_is_sbt?).to be false
    end

    it '3+x-4 to true' do
      expect('3+x-4'._outer_func_is_sbt?).to be true
    end

    it '3+x+-4 to false' do
      expect('3+x+-4'._outer_func_is_sbt?).to be false
    end

    it '-3+-4 to false' do
      expect('-3+-4'._outer_func_is_sbt?).to be false
    end
  end

  describe '#_outer_func_is_mtp?' do
    it '3x to true' do
      expect('3x'._outer_func_is_mtp?).to be true
    end

    it '3+x to false' do
      expect('3+x'._outer_func_is_mtp?).to be false
    end

    it '3-x to false' do
      expect('3-x'._outer_func_is_mtp?).to be false
    end

    it '-3x to true' do
      expect('-3x'._outer_func_is_mtp?).to be true
    end

    it '\frac{$$$}{$$}($$$$$) to true' do
      expect('\frac{$$$}{$$}($$$$$)'._outer_func_is_mtp?).to be true
    end

    it '\frac{$$$}{$$} to false' do
      expect('\frac{$$$}{$$}'._outer_func_is_mtp?).to be false
    end

    it '-12 to false' do
      expect('-12'._outer_func_is_mtp?).to be false
    end

    it 'x to false' do
      expect('x'._outer_func_is_mtp?).to be false
    end

    it 'xy to true' do
      expect('xy'._outer_func_is_mtp?).to be true
    end

    it 'x^3 to false' do
      expect('x^3'._outer_func_is_mtp?).to be false
    end

    it '($$$)^{$$$$} to false' do
      expect('($$$)^{$$$$}'._outer_func_is_mtp?).to be false
    end

    it '($$$)^{$$$$}3 to true' do
      expect('($$$)^{$$$$}3'._outer_func_is_mtp?).to be true
    end

    it '($$$)^3\frac{$}{$} to true' do
      expect('($$$)^3\frac{$}{$}'._outer_func_is_mtp?).to be true
    end

    it '-' do
      expect('-'._outer_func_is_mtp?).to be false
    end
  end

  describe '#_outer_func_is_div?' do
    it 'x^3 to false' do
      expect('x^3'._outer_func_is_div?).to be false
    end

    it '\frac{$$}{$}' do
      expect('\frac{$$}{$}'._outer_func_is_div?).to be true
    end

    it '\frac{$$}{$}x' do
      expect('\frac{$$}{$}x'._outer_func_is_div?).to be false
    end
  end

  describe '#_outer_func_is_pow' do
    it 'x^3 to true' do
      expect('x^3'._outer_func_is_pow?).to be true
    end

    it 'x^3y to false' do
      expect('x^3y'._outer_func_is_pow?).to be false
    end

    it '12^3 to true' do
      expect('12^3'._outer_func_is_pow?).to be true
    end

    it 'x^3+4 to false' do
      expect('x^3+4'._outer_func_is_pow?).to be false
    end

    it '-4^3 to false' do
      expect('-4^3'._outer_func_is_pow?).to be false
    end

    it '-4^3-5 to false' do
      expect('-4^3-5'._outer_func_is_pow?).to be false
    end
  end

  describe '#_is_numeral' do
    it '123 to true' do
      expect('123'._is_numeral?).to be true
    end

    it '-123 to true' do
      expect('-123'._is_numeral?).to be true
    end

    it '-1x3 to false' do
      expect('-1x3'._is_numeral?).to be false
    end

    it '- to false' do
      expect('-'._is_numeral?).to be false
    end
  end

  describe '#_is_string_var' do
    it 'x to true' do
      expect('x'._is_string_var?).to be true
    end

    it '3 to false' do
      expect('3'._is_string_var?).to be false
    end

    it 'xy to false' do
      expect('xy'._is_string_var?).to be false
    end

    it '\ to false' do
      expect('\\'._is_string_var?).to be false
    end
  end
end
