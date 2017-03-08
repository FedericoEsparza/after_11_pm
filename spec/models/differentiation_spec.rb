describe Differentiation do
  describe '#initialize' do
    it 'initialise with an expression and differentiation variable' do
      exp = diff(pow('x',2),'x')
      expect(exp.func).to eq pow('x',2)
      expect(exp.var).to eq 'x'
    end
  end

  describe 'setters for func and var' do
    it 'setter for func' do
      exp = diff(pow('x',2),'x')
      exp.func = pow('x',3)
      expect(exp.func).to eq pow('x',3)
    end

    it 'setter for var' do
      exp = diff(pow('x',2),'x')
      exp.var = 'y'
      expect(exp.var).to eq 'y'
    end
  end

  xdescribe '#evaluate' do
    # some tests may have error!
    it 'returns an array of steps for differenting x^3+x^2' do
      # exp = diff(add(pow('x',3),pow('x',2)),'x')
      #below is the superfactory form of the above in comment
      exp = diff('x^3+x^2'.objectify,'x')
      results = exp.evaluate
      expect(results).to eq [
        diff('x^3+x^2'.objectify,'x'),
        '3x^{3-1}+2x^{2-1}'.objectify,
        '3x^2+2x^1'.objectify,
        '3x^2+2x'.objectify
      ]
    end

    it 'returns an array of steps for differenting 2x^3+4x^{-2}' do
      exp = diff('2x^3+4x^{-2}'.objectify,'x')
      results = exp.evaluate
      expect(results).to eq [
        diff('2x^3+4x^{-2}'.objectify,'x'),
        '2\times3x^{3-1}+4\times(-2)x^{2-1}'.objectify,
        '6x^2-8x^1'.objectify,
        '6x^2-8x'.objectify
      ]
    end

    it 'returns an array of steps for differenting 2x^3' do
      # exp = diff('2x^3'.objectify,'x')
      # the above is shortcut superfactory method for below
      exp = diff(mtp(2,pow('x',3)).objectify,'x')
      results = exp.evaluate
      expect(results).to eq [
        diff('2x^3'.objectify,'x'),
        '2\times3x^{3-1}'.objectify,
        '6x^2'.objectify,
      ]
    end

    it 'returns an array of steps for differenting 2x - 5' do
      exp = diff(add(mtp(2,'x'),-5),'x')
      results = exp.evaluate
      expect(results).to eq [
        diff('2x-5'.objectify,'x'),
        2
      ]
    end

    it 'returns an array of steps for differentiating (2x+3)(3x-4)' do
      exp = diff('(2x+3)(3x-4)'.objectify,'x')

      # you should call combine_brackets on (2x+3)(3x-4)
      expanded_result = '(2x+3)(3x-4)'.objectify.combine_brackets
      puts expanded_result[0].latex.shorten
      puts expanded_result[1].latex.shorten
      puts expanded_result[2].latex.shorten
      puts expanded_result[3].latex.shorten
      puts expanded_result[4].latex.shorten
      puts expanded_result[5].latex.shorten
      puts expanded_result[6].latex.shorten

      results = exp.evaluate
      expect(results).to eq [
        diff('(2x+3)(3x-4)'.objectify,'x'),
        diff('(2x)(3x)+(2x)(-4)+(3)(3x)+(3)(-4)'.objectify,'x'),
        diff('(2\times3)(xx)+(2\times-4)x+(3\times3)x+(3\times-4)'.objectify,'x'),
        diff('6(x^1x^1)-8x+9x-12'.objectify,'x'),
        diff('6x^{1+1}+8x+9x-12'.objectify,'x'),
        diff('6x^2-8x+9x-12'.objectify,'x'),
        diff('6x^2+x-12'.objectify,'x'),
        '6\times2x^{2-1}+1'.objectify,
        '12x^{1}+1'.objectify,
        '12x+1'.objectify
      ]
    end

    it 'returns an array of steps for differentiating (2x^2-3x)(4+x^{-3})(3-5x^{-2})' do

    end
  end
end
