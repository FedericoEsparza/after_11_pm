describe SimutaneousEqnSubstitution do

  describe '#initialize' do
    it 'initializes x+y=10, 2x+y=5' do
      sseqns = sseqn(eqn(add('x','y'),10),eqn(add(mtp(2,'x'),'y'),5))

      expect(sseqns.eqns[0]).to eq eqn(add('x','y'),10)
      expect(sseqns.eqns[1]).to eq eqn(add(mtp(2,'x'),'y'),5)
      expect(sseqns.vars).to eq ['x','y']

    end
  end

  describe '#new_eqn' do
    it 'subs x+2y=5, 5x+3y=15' do
      equations = sseqn(eqn(add('x',mtp(2,'y')),5),eqn(add(mtp(5,'x'),mtp(3,'y')),15))

      result = equations.new_eqn

      expect(result).to eq eqn(add(mtp(5,add(5,mtp(-2,'y'))),mtp(3,'y')),15)
    end
  end

  describe '#generate_solution' do
    it 'sovles x+5y=20, 2x+2y=24' do
      equations = sseqn('x+5y=20'.objectify, '2x+2y=24'.objectify)

      result = equations.generate_solution


    end
  end

  describe '#latex' do
    it 'latexes x+2y=5, 5x+3y=15' do
      equations = sseqn(eqn(add('x',mtp(2,'y')),5),eqn(add(mtp(5,'x'),mtp(3,'y')),15))
      result = equations.latex

      expect(result).to eq '&&x+2y&=5&\left(1\right)&&&&\\\[5pt]
      &&5x+3y&=15&\left(2\right)&&&&\\\[15pt]
    '
    end
  end

  describe '#solution_latex' do
    it 'latexes solution of x+2y=5, 5x+3y=4' do
      equations = sseqn('x+2y=5'.objectify,'5x+3y=4'.objectify)
      result =  equations.solution_latex
      expect(result).to eq "\\begin{align*}&&x+2y&=5&\\left(1\\right)&&&&\\\\[5pt]\n      &&5x+3y&=4&\\left(2\\right)&&&&\\\\[15pt]\n    &\\text{Rearrange (1)}&x&=5-2y&\\left(3\\right)&\\\\[15pt]&\\text{Sub (3) into (2)}&5\\left(5-2y\\right)+3y&=4&\\\\[5pt]&&5\\times5+5\\times-2y+3y&=4&\\\\[5pt]&&25-10y+3y&=4&\\\\[5pt]&&-7y+25&=4&\\\\[5pt]&&-7y&=4-25&\\\\[5pt]&&-7y&=-21&\\\\[5pt]&&y&=\\displaystyle\\frac{-21}{-7}&\\\\[5pt]&&y&=3&\\\\[15pt]&\\text{Sub y into (3)}&x&=5-2\\times3&\\\\[5pt]&&x&=5-6&\\\\[5pt]&&x&=-1&\\\\[5pt]\\end{align*}\n    $x=1\\,\\,\\,$ and $\\,\\,\\,y=3$"
    end

    it 'latexes solution of x+5y=20, 2x+2y=24' do
      equations = sseqn('x+5y=20'.objectify, '2x+2y=24'.objectify)
      result = equations.solution_latex
      expect(result).to eq "\\begin{align*}&&x+5y&=20&\\left(1\\right)&&&&\\\\[5pt]\n      &&2x+2y&=24&\\left(2\\right)&&&&\\\\[15pt]\n    &\\text{Rearrange (1)}&x&=20-5y&\\left(3\\right)&\\\\[15pt]&\\text{Sub (3) into (2)}&2\\left(20-5y\\right)+2y&=24&\\\\[5pt]&&2\\times20+2\\times-5y+2y&=24&\\\\[5pt]&&40-10y+2y&=24&\\\\[5pt]&&-8y+40&=24&\\\\[5pt]&&-8y&=24-40&\\\\[5pt]&&-8y&=-16&\\\\[5pt]&&y&=\\displaystyle\\frac{-16}{-8}&\\\\[5pt]&&y&=2&\\\\[15pt]&\\text{Sub y into (3)}&x&=20-5\\times2&\\\\[5pt]&&x&=20-10&\\\\[5pt]&&x&=10&\\\\[5pt]\\end{align*}\n    $x=10\\,\\,\\,$ and $\\,\\,\\,y=2$"
    end

  end

end
