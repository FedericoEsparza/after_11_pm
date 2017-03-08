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

  describe '#solve_eqns' do
    it 'sovles x+2y=5, 5x+3y=15' do
      equations = sseqn(eqn(add('x',mtp(2,'y')),5),eqn(add(mtp(5,'x'),mtp(3,'y')),15))

      result = equations.solve_eqns
      result.each{|a| puts a.latex}
    end
  end

  describe '#latex' do
    it 'latexes x+2y=5, 5x+3y=15' do
      equations = sseqn(eqn(add('x',mtp(2,'y')),5),eqn(add(mtp(5,'x'),mtp(3,'y')),15))
      result = equations.latex
      # puts result
    end
  end

end
