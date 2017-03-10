describe FactoriseQuadraticEquation do

  describe '#factorise_standard_quadractic' do
    it 'factorises 0=3z^2-z-2' do
      exp = '0=3z^2-z-2'.objectify
      result = exp.factorise_standard_quadractic

      expect(result[:steps]).to eq [
        '0=3z^2-z-2'.objectify,
        eqn(0,mtp(add('z',-1),add('z',frac(2,3))))
      ]
      expect(result[:P]).to eq [mtp(3,-2),-6]
      expect(result[:S]).to eq -1
      expect(result[:factors]).to eq [[-3,2],[frac(-3,3),frac(2,3)],[-1,frac(2,3)]]
    end
  end

  describe '#convert_rational_steps' do
    it 'converts 1\(x+1) + 2\(2x-3)=5' do
      exp = eqn(add(div(1,add('x',1)),div(2,add(mtp(2,'x'),-3))),5)
      result = exp.convert_rational_steps

      expect(result[0]).to eq eqn(add(div(1,add('x',1)),div(2,add(mtp(2,'x'),-3))),5)
      expect(result[1]).to eq eqn(add(mtp(div(1,add('x',1)),add('x',1)),mtp(div(2,add(mtp(2,'x'),-3)),add('x',1))),mtp(5,add('x',1)))
      expect(result[2]).to eq eqn(add(1,div(mtp(2,add('x',1)),add(mtp(2,'x'),-3))),mtp(5,add('x',1)))
      expect(result[3]).to eq eqn(add(mtp(1,add(mtp(2,'x'),-3)),mtp(div(mtp(2,add('x',1)),add(mtp(2,'x'),-3)),add(mtp(2,'x'),-3))),mtp(5,add('x',1),add(mtp(2,'x'),-3)))
      expect(result[4]).to eq eqn(add(mtp(1,add(mtp(2,'x'),-3)),mtp(2,add('x',1))),mtp(5,add('x',1),add(mtp(2,'x'),-3)))
      expect(result[5]).to eq nil

    end
  end

  describe '#standardize_quadractic' do
    it 'standardises 1\(y^2+1) + 2\(2y^2-3)=5' do
      exp = eqn(add(div(1,add(pow('y',2),1)),div(2,add(mtp(2,pow('y',2)),-3))),5)
      result = exp.standardize_quadractic(pow('y',2))

      # result.each{|a| puts a.latex + '\\\[5pt]'}

    end

  end

  describe '#factorise_quadractic' do
    it 'factorises 6\(x+1) + 3\(2x-3)=1 for y^2' do

      exp = eqn(add(div(8,add(pow('y',2),1)),div(3,add(mtp(2,pow('y',2)),-3))),1)
      result = exp.factorise_quadractic(pow('y',2))

      result[:steps].each{|a| puts a.latex + '\\\[5pt]'}

      # expect(result[:P]).to eq [mtp(2,18),36]
      # expect(result[:S]).to eq -20
      # expect(result[:factors]).to eq [[-2,-18],[frac(-2,2),frac(-18,2)],[-1,-9]]

    end
  end
end
