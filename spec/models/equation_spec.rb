describe Equation do
  # describe '#initialize' do
  #   it 'initialise with a left hand side and a right hand side' do
  #     eqn = eqn('x',3)
  #     expect(eqn.ls).to eq 'x'
  #     expect(eqn.rs).to eq 3
  #   end
  # end
  #
  # describe '#solve_one_var_eqn' do
  #   context '#one-step' do
  #     it 'reverses one step right addition' do
  #       eqn = eqn(add(3,'x'),5)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(add(3,'x'),5),
  #         eqn('x',sbt(5,3)),
  #         eqn('x',2)
  #       ]
  #     end
  #
  #     it 'reverses one step left addition' do
  #       eqn = eqn(add('x',3),5)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(add('x',3),5),
  #         eqn('x',sbt(5,3)),
  #         eqn('x',2)
  #       ]
  #     end
  #
  #     it 'reverses one step right multiplication' do
  #       eqn = eqn(mtp('x',3),15)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(mtp('x',3),15),
  #         eqn('x',div(15,3)),
  #         eqn('x',5)
  #       ]
  #     end
  #
  #     it 'reverses one step left multiplication' do
  #       eqn = eqn(mtp(3,'x'),15)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(mtp(3,'x'),15),
  #         eqn('x',div(15,3)),
  #         eqn('x',5)
  #       ]
  #     end
  #
  #     it 'reverses one step right subtraction' do
  #       eqn = eqn(sbt('x',3),5)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(sbt('x',3),5),
  #         eqn('x',add(5,3)),
  #         eqn('x',8)
  #       ]
  #     end
  #
  #     it 'reverses one step left subtraction' do
  #       eqn = eqn(sbt(5,'x'),3)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(sbt(5,'x'),3),
  #         eqn('x',sbt(5,3)),
  #         eqn('x',2)
  #       ]
  #     end
  #
  #     it 'reverses one step right division' do
  #       eqn = eqn(div('x',3),5)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(div('x',3),5),
  #         eqn('x',mtp(5,3)),
  #         eqn('x',15)
  #       ]
  #     end
  #
  #     it 'reverses one step left division' do
  #       eqn = eqn(div(6,'x'),3)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(div(6,'x'),3),
  #         eqn('x',div(6,3)),
  #         eqn('x',2)
  #       ]
  #     end
  #   end
  #
  #   context '#two-steps' do
  #     it 'solves 2x + 3 = 15' do
  #       eqn = eqn(add(mtp(2,'x'),3),15)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(add(mtp(2,'x'),3),15),
  #         eqn(mtp(2,'x'),sbt(15,3)),
  #         eqn(mtp(2,'x'),12),
  #         eqn('x',div(12,2)),
  #         eqn('x',6)
  #       ]
  #     end
  #
  #     it 'solves 20 - 3x = 5' do
  #       eqn = eqn(sbt(20,mtp('x',3)),5)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(sbt(20,mtp('x',3)),5),
  #         eqn(mtp('x',3),sbt(20,5)),
  #         eqn(mtp('x',3),15),
  #         eqn('x',div(15,3)),
  #         eqn('x',5)
  #       ]
  #     end
  #   end
  #
  #   context '#three-steps' do
  #     it 'solves 30/(16-2x) = 3' do
  #       eqn = eqn(div(30,sbt(16,mtp(2,'x'))),3)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(div(30,sbt(16,mtp(2,'x'))),3),
  #         eqn(sbt(16,mtp(2,'x')),div(30,3)),
  #         eqn(sbt(16,mtp(2,'x')),10),
  #         eqn(mtp(2,'x'),sbt(16,10)),
  #         eqn(mtp(2,'x'),6),
  #         eqn('x',div(6,2)),
  #         eqn('x',3)
  #       ]
  #     end
  #   end
  #
  #   context '#four-steps' do
  #     it 'solves 9 + 36 / (7x - 2) = 12' do
  #       eqn = eqn(add(9,div(36,sbt(mtp(7,'x'),2))),12)
  #       result = eqn.solve_one_var_eqn
  #       expect(result).to eq [
  #         eqn(add(9,div(36,sbt(mtp(7,'x'),2))),12),
  #         eqn(div(36,sbt(mtp(7,'x'),2)),sbt(12,9)),
  #         eqn(div(36,sbt(mtp(7,'x'),2)),3),
  #         eqn(sbt(mtp(7,'x'),2),div(36,3)),
  #         eqn(sbt(mtp(7,'x'),2),12),
  #         eqn(mtp(7,'x'),add(12,2)),
  #         eqn(mtp(7,'x'),14),
  #         eqn('x',div(14,7)),
  #         eqn('x',2)
  #       ]
  #     end
  #   end
  # end

  describe '#expand_quad_eqn' do
    it 'expands (x+2)^2= x-2 ' do
      eqn = eqn(pow(add('x',2),2),add('x',-2))
      result = eqn.expand_quad_eqn

      # result.each_with_index do |a,i|
      #   string = "expect(result[" + i.to_s + "]).to eq '" + a.latex.shorten + "'.objectify"
      #   puts string
      # end

      expect(result[0]).to eq eqn('(x+2)^2'.objectify,'x-2'.objectify)
      expect(result[1]).to eq eqn('(x+2)(x+2)'.objectify,'x-2'.objectify)
      expect(result[2]).to eq eqn('xx+x2+2x+2\times2'.objectify,'x-2'.objectify)
      expect(result[3]).to eq eqn('x^1x^1+x2+2x+4'.objectify,'x-2'.objectify)
      expect(result[4]).to eq eqn('x^{1+1}+x2+2x+4'.objectify,'x-2'.objectify)
      expect(result[5]).to eq eqn('x^2+x2+2x+4'.objectify,'x-2'.objectify)
      expect(result[6]).to eq eqn('x^2+2x+2x+4'.objectify,'x-2'.objectify)
      expect(result[7]).to eq eqn('x^2+4x+4'.objectify,'x-2'.objectify)


    end
  end

  describe '#simplify_quad_eqn' do
    it 'simplifies x^2+4x+4=x-2' do
      eqn = eqn('x^2+4x+4'.objectify,'x-2'.objectify)
      result = eqn.simplify_quad_eqn

      expect(result).to eq [
        'x^2+4x+4-(x+-2)=0'.objectify,
        'x^2+3x+6=0'.objectify
        ]

    end
  end

  describe '#solve_quad_eqn' do
    it 'solves (x+2)^2= x-2' do
      eqn = eqn(pow(add('x',2),2),add('x',-2))
      result = eqn.solve_quad_eqn

      expect(result[0]).to eq eqn('(x+2)^2'.objectify,'x-2'.objectify)
      expect(result[1]).to eq eqn('(x+2)(x+2)'.objectify,'x-2'.objectify)
      expect(result[2]).to eq eqn('xx+x2+2x+2\times2'.objectify,'x-2'.objectify)
      expect(result[3]).to eq eqn('x^1x^1+x2+2x+4'.objectify,'x-2'.objectify)
      expect(result[4]).to eq eqn('x^{1+1}+x2+2x+4'.objectify,'x-2'.objectify)
      expect(result[5]).to eq eqn('x^2+x2+2x+4'.objectify,'x-2'.objectify)
      expect(result[6]).to eq eqn('x^2+2x+2x+4'.objectify,'x-2'.objectify)
      expect(result[7]).to eq eqn('x^2+4x+4'.objectify,'x-2'.objectify)
      expect(result[8]).to eq 'x^2+4x+4-(x-2)=0'.objectify
      expect(result[9]).to eq 'x^2+3x+6=0'.objectify

    end
  end

  describe '#latex_quad_solution' do
    it 'latexes (x+2)^2= -x-2' do
      eqn = eqn(pow(add('x',2),2),add(mtp(-1,'x'),-2))
      result = eqn.latex_quad_solution
      expect(result).to eq "\\begin{align*}\n    \\left(x+2\\right)^2&=-1x-2&\\\\[5pt]\n      \\left(x+2\\right)\\left(x+2\\right)&=-1x-2&\\\\[5pt]\n      xx+x2+2x+2\\times2&=-1x-2&\\\\[5pt]\n      x^1x^1+x2+2x+4&=-1x-2&\\\\[5pt]\n      x^{1+1}+x2+2x+4&=-1x-2&\\\\[5pt]\n      x^2+x2+2x+4&=-1x-2&\\\\[5pt]\n      x^2+2x+2x+4&=-1x-2&\\\\[5pt]\n      x^2+4x+4&=-1x-2&\\\\[5pt]\n      x^2+4x+4-\\left(-1x+-2\\right)&=0&\\\\[5pt]\n      x^2+5x+6&=0&\\\\[5pt]\n      0&=x^2+5x+6& && &P=6 \\hspace{30pt}S=5&\\\\[5pt]\n    0&=\\left(x+2\\right)\\left(x+3\\right)& && &\\left(2,\\,\\,3\\right)\\hspace{10pt}&\\\\[5pt]\n    x&=-2 ,\\,\\, -3\\\\[5pt]\n    \\end{align*}"

    end

    it 'latexes (x-4)(x+2)=2x+4' do
      eqn = '(x-4)(x+2)=2x+4'.objectify
      result = eqn.latex_quad_solution
      expect(result).to eq "\\begin{align*}\n    \\left(x-4\\right)\\left(x+2\\right)&=2x+4&\\\\[5pt]\n      \\left(x-4\\right)\\left(x+2\\right)&=2x+4&\\\\[5pt]\n      xx+x2-4x-4\\times2&=2x+4&\\\\[5pt]\n      x^1x^1+x2-4x-8&=2x+4&\\\\[5pt]\n      x^{1+1}+x2-4x-8&=2x+4&\\\\[5pt]\n      x^2+x2-4x-8&=2x+4&\\\\[5pt]\n      x^2+2x-4x-8&=2x+4&\\\\[5pt]\n      x^2-2x-8&=2x+4&\\\\[5pt]\n      x^2-2x-8-\\left(2x+4\\right)&=0&\\\\[5pt]\n      x^2-4x-12&=0&\\\\[5pt]\n      0&=x^2-4x-12& && &P=-12 \\hspace{30pt}S=-4&\\\\[5pt]\n    0&=\\left(x-6\\right)\\left(x+2\\right)& && &\\left(-6,\\,\\,2\\right)\\hspace{10pt}&\\\\[5pt]\n    x&=6 ,\\,\\, -2\\\\[5pt]\n    \\end{align*}"
    end

    it 'latexes (x+1)(2x-4)=2x-6' do
      eqn = '(x+1)(2x-4)=2x-6'.objectify
      result = eqn.latex_quad_solution
      expect(result).to eq "\\begin{align*}\n    \\left(x+1\\right)\\left(2x-4\\right)&=2x-6&\\\\[5pt]\n      \\left(x+1\\right)\\left(2x-4\\right)&=2x-6&\\\\[5pt]\n      x2x+x-4+2x+-4&=2x-6&\\\\[5pt]\n      xx2+x-4+2x+-4&=2x-6&\\\\[5pt]\n      x^1x^12+x-4+2x-4&=2x-6&\\\\[5pt]\n      x^{1+1}2+x-4+2x-4&=2x-6&\\\\[5pt]\n      x^22+x-4+2x-4&=2x-6&\\\\[5pt]\n      2x^2+-4x+2x-4&=2x-6&\\\\[5pt]\n      2x^2-2x-4&=2x-6&\\\\[5pt]\n      2x^2-2x-4-\\left(2x+-6\\right)&=0&\\\\[5pt]\n      2x^2+-4x+2&=0&\\\\[5pt]\n      0&=2x^2+-4x+2& && &P=2\\times2=4 \\hspace{30pt}S=-4&\\\\[5pt]\n    0&=\\left(x-1\\right)\\left(x-1\\right)& && &\\left(-2,\\,\\,-2\\right)\\hspace{10pt}\\left(\\frac{-2}{2},\\,\\,\\frac{-2}{2}\\right)\\hspace{10pt}\\left(-1,\\,\\,-1\\right)\\hspace{10pt}&\\\\[5pt]\n    x&=1 ,\\,\\, 1\\\\[5pt]\n    \\end{align*}"
    end
  end


end
